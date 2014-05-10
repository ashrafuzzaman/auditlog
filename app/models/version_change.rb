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

  def table_name
    @table_name ||= version.trackable_type.underscore
  end

  def i18n_prefix
    @i18n_prefix ||= "auditlog.models.#{table_name}.#{field}"
  end

  def i18n_default_prefix
    @default_prefix ||= "auditlog.models.#{field}"
  end

  def readable_message
    klass = version.trackable_type.constantize
    reflection = klass.reflections.select { |association, relation| relation.foreign_key.to_sym == field.to_sym }

    field_was, field_now = self.was, self.now
    if reflection && !reflection.empty?
      field_was = readable_association_name(reflection, field_was)
      field_now = readable_association_name(reflection, field_now)
    end
    params = {was: field_was, now: field_now}

    if self.was.nil? || self.was.to_s == ''
      i18n_message(:set, params)
    elsif self.now.nil? || self.now.to_s == ''
      i18n_message(:unset, params)
    else
      i18n_message(:changed, params)
    end
  end

  private
  def readable_association_name(reflection, id)
    association_klass = reflection.values.first.class_name.to_s.constantize
    auditlog_name_method = association_klass.try(:auditlog_name_method)
    raise "Please auditlog_name_as for the class #{association_klass_name}" if auditlog_name_method.nil? || auditlog_name_method == ''
    association_klass.find(id).send(auditlog_name_method) rescue nil if id.to_i > 0
  end

  def i18n_message(type, params)
    I18n.t(:"#{i18n_prefix}.#{type.to_s}", {default: ["#{i18n_default_prefix}.#{type.to_s}".to_sym]}.merge(params))
  end
end