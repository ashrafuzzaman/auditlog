class VersionChange < ActiveRecord::Base
  attr_accessible :version_id, :field, :now, :was

  belongs_to :version

  def self.for(options={})
    version_changes = VersionChange.includes(:version).joins(:version)

    if options[:field]
      fields = options[:field].kind_of?(Array) ? options[:field].collect(&:to_s) : options[:field].to_s
      version_changes = version_changes.where(field: fields)
    end
    if options[:type] and options[:id]
      version_changes = version_changes.where("versions.trackable_type = ? AND trackable_id IN (?)", options[:type].to_s, options[:id])
    end

    events = options[:events]
    if events
      events = events.kind_of?(Array) ? events.collect(&:to_s) : [events.to_s]
      version_changes = version_changes.where("versions.event IN (?)", events)
    end
    version_changes
  end

end