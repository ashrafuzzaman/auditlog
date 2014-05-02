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

    def version_changes(options={})
      VersionChange.for(field: options[:field],
                        type: self.class.name.to_s,
                        id: self.id,
                        events: options[:events]).order('created_at ASC')
    end

    #def readable_changes(version_changes)
    #end
  end
end