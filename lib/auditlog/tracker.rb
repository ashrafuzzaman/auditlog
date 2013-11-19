module Auditlog
  class Tracker
    def self.track_changes(model, options)
      meta = options[:meta]
      column_names = model.class.column_names.collect { |col| col.to_sym }
      only = options[:only] || column_names
      except = [:id, :updated_at, :created_at] + (options[:except] || [])

      except = (except + (column_names - only)).uniq

      changes = model.changes.clone
      changes = changes.delete_if { |attr, change| (change[0] == change[1]) or except.include?(attr.to_sym) }

      unless changes.empty?
        event = model.id_changed? ? 'create' : 'update'
        version = Version.new(event: event)

        meta.each do |meta_attr|
          meta_value = model.send(meta_attr)
          version.send("#{meta_attr.to_s}=", meta_value)
        end if meta.present?

        version.trackable = model
        changes.each do |field, changes|
          version.version_changes.build(field: field, was: changes[0], now: changes[1])
        end

        version.save!
      end
    end
  end
end