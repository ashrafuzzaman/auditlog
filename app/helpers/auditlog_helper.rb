module AuditlogHelper
  def render_auditlog_changes(changes)
    content_tag :ul do
      content_tag_for(:li, changes) do |change|
        version = change.version
        klass_name = version.trackable_type.underscore
        field = change.field
        prefix = "auditlog.models.#{klass_name}.#{field}"
        params = {was: change.was, now: change.now}
        if change.was.nil? || change.was.to_s == ''
          I18n.t("#{prefix}.set", params)
        elsif change.now.nil? || change.now.to_s == ''
          I18n.t("#{prefix}.unset", params)
        else
          I18n.t("#{prefix}.changed", params)
        end
      end
    end
  end
end