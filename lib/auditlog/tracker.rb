module Auditlog
  class Tracker
    def self.track_changes(model, options)
      if model.class.name == "Story"
        p "tracking change for"
        p model.inspect
      end
      meta = options[:meta]
      column_names = model.class.column_names.collect { |col| col.to_sym }
      only = options[:only] || column_names
      notify = options[:notify] || {}
      except = [:id, :updated_at, :created_at] + (options[:except] || [])

      except = (except + (column_names - only)).uniq

      changes = model.changes.clone
      changes = changes.delete_if { |attr, change| (change[0] == change[1]) or except.include?(attr.to_sym) }

      unless changes.empty?
        event = model.id_changed? ? 'create' : 'update'
        version = model.versions.build(event: event)

        meta.each do |meta_attr|
          meta_value = model.send(meta_attr)
          version.send("#{meta_attr.to_s}=", meta_value)
        end if meta.present?

        changes.each do |field, changes|
          version.version_changes.build(field: field, was: changes[0], now: changes[1])
        end

        version.save!
        # now notify the dependencies notify
        unless notify.empty?
          notify.each do |relation, columns|
            relation_ref = model.send relation
            ap [relation_ref, relation_ref.class.name.to_s, relation_ref.id]

            if relation_ref
              notify_fields = []
              changes.each do |field, changes|
                notify_fields << field if columns.include?(field.to_sym)
              end

              changes_to_notify = version.version_changes.where(field: notify_fields)
              changes_to_notify.each do |change_to_notify|
                change_notification = change_to_notify.change_notifications.build
                change_notification.model = relation_ref
                change_notification.save!
              end
            end
          end
        end

        version
      end
    end
  end
end