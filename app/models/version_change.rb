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

  def readable_message
    version = self.version
    klass_name = version.trackable_type.underscore
    klass = version.trackable_type.constantize
    field = self.field
    reflection = klass.reflections.select { |association, relation| relation.foreign_key.to_sym == field.to_sym }

    prefix = "auditlog.models.#{klass_name}.#{field}"
    was, now = self.was, self.now
    if reflection
      was = readable_association_name(reflection, was)
      now = readable_association_name(reflection, now)
    end
    params = {was: was, now: now}

    if self.was.nil? || self.was.to_s == ''
      I18n.t("#{prefix}.set", params)
    elsif self.now.nil? || self.now.to_s == ''
      I18n.t("#{prefix}.unset", params)
    else
      I18n.t("#{prefix}.changed", params)
    end
  end

  private
  def readable_association_name(reflection, value)
    association_klass = reflection.values.first.class_name.to_s.constantize
    auditlog_name_method = association_klass.try(:auditlog_name_method)
    raise "Please auditlog_name_as for the class #{association_klass_name}" if auditlog_name_method.nil? || auditlog_name_method == ''
    association_klass.find(value).send(auditlog_name_method) rescue nil if value.to_i > 0
  end
end