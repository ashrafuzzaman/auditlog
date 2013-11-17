module Auditlog
  class Tracker
    def self.track_changes(model, options)
      meta = options[:meta]
      column_names = model.class.column_names.collect{ |col| col.to_sym }
      only = options[:only] || column_names
      except = [:id, :updated_at, :created_at] + (options[:except] || [])

      except = (except + (column_names - only)).uniq

      changes = model.changes.clone
      changes = changes.delete_if { |attr, change| (change[0] == change[1]) or except.include?(attr.to_sym) }

      ap changes

      unless changes.empty?
        meta_attrs = Hash[(meta || {}).collect { |k, v| [k, v.is_a?(Symbol) ? model.send(v) : v.call(model)] }]
        Rails.logger.debug "meta_attrs :: #{meta_attrs.inspect}"

        version = Version.new({event: 'save'})
        version.trackable = model
        changes.each do |field, changes|
          version.version_changes.build(field: field, was: changes[0], now: changes[1])
        end

        version.save!
      end
    end
  end
end