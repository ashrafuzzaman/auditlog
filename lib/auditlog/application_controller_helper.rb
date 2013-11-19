require 'active_support/concern'
require 'auditlog/data'

module Auditlog
  module ApplicationControllerHelper
    extend ActiveSupport::Concern

    def set_auditlog_done_by_id
      Auditlog::Data.current_user_id = current_user.try(:id)
    end

    included do
      before_filter :set_auditlog_done_by_id
    end
  end
end