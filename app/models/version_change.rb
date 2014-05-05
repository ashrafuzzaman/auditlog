class VersionChange < ActiveRecord::Base
  belongs_to :version
  has_many :change_notifications, class_name: 'AuditlogChangeNotification'

  def self.for(options={})
    version_changes = VersionChange.includes(:version).joins(:version)

    if options[:field]
      fields = options[:field].kind_of?(Array) ? options[:field].collect(&:to_s) : options[:field].to_s
      version_changes = version_changes.where(field: fields)
    end
    if options[:type] && options[:id]
      version_changes = version_changes.joins("LEFT JOIN auditlog_change_notifications ON auditlog_change_notifications.version_change_id = version_changes.id").
          where("(versions.trackable_type = :type AND trackable_id IN (:ids)) OR (auditlog_change_notifications.model_type = :type AND auditlog_change_notifications.model_id IN (:ids))",
                type: options[:type].to_s, ids: options[:id])
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
    default_prefix = "auditlog.models.#{field}"

    was, now = self.was, self.now
    if reflection && !reflection.empty?
      was = readable_association_name(reflection, was)
      now = readable_association_name(reflection, now)
    end
    params = {was: was, now: now}

    if self.was.nil? || self.was.to_s == ''
      I18n.t("#{prefix}.set", {default: ["#{default_prefix}.set".to_sym]}.merge(params))
    elsif self.now.nil? || self.now.to_s == ''
      I18n.t("#{prefix}.unset", {default: ["#{default_prefix}.unset".to_sym]}.merge(params))
    else
      I18n.t("#{prefix}.changed", {default: ["#{default_prefix}.changed".to_sym]}.merge(params))
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