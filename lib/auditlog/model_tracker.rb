require 'active_support/concern'
require 'auditlog/tracker'

module Auditlog
  module ModelTracker
    extend ActiveSupport::Concern

    module ClassMethods
      def track(options = {})
        self.after_save do
          Auditlog::Tracker.track_changes(self, options)
        end
      end
    end

    #def self.included(receiver)
    #  receiver.extend ClassMethods
    #end

    included do
      has_many :versions, as: :trackable

      #scope :disabled, -> { where(disabled: true) }
    end
  end
end

#ActiveSupport.on_load(:active_record) do
#  include AuditlogTracker
#end