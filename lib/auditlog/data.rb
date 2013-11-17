require 'request_store'

module Auditlog
  class Data
    def self.current_user_id=(id)
      RequestStore.store[:auditlog_done_by_id] = id
    end

    def self.current_user_id
      RequestStore.store[:auditlog_done_by_id]
    end
  end
end