module AuditlogHelper
  def render_auditlog_changes(changes)
    content_tag :ul do
      content_tag_for(:li, changes) do |change|
        change.readable_message
      end
    end
  end
end