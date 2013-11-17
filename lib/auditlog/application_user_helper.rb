module Auditlog
  class ApplicationUserHelper
    def set_auditlog_done_by_id
      Auditlog::Data.current_user_id = current_user.try(:id)
    end
  end
end