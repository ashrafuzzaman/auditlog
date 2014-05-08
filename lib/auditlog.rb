require "auditlog/engine"

module Auditlog
end

require 'auditlog/model_tracker'
ActiveSupport.on_load(:active_record) do
  include Auditlog::ModelTracker
end