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

    included do
      has_many :versions, as: :trackable
    end
  end
end