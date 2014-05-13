require 'active_support/concern'
require 'auditlog/tracker'

module Auditlog
  module ModelTracker
    extend ActiveSupport::Concern

    module ClassMethods
      def track(options = {})
        if ::ActiveRecord::VERSION::MAJOR >= 4 # `has_many` syntax for specifying order uses a lambda in Rails 4
          has_many :versions, -> { order('created_at DESC') }, as: :trackable
          has_many :version_changes, -> { order('created_at DESC') }, through: :versions
        else
          has_many :versions, as: :trackable, order: 'created_at DESC'
          has_many :version_changes, through: :versions, order: 'created_at DESC'
        end

        self.after_save do
          Auditlog::Tracker.track_changes(self, options)
        end
      end

      def auditlog_name_as(field)
        @auditlog_name_method = field
      end

      def auditlog_name_method
        @auditlog_name_method
      end
    end

    #def version_changes(options={})
    #  VersionChange.for(field: options[:field],
    #                    type: self.class.name.to_s,
    #                    id: self.id,
    #                    events: options[:events]).order('created_at DESC')
    #end
  end
end