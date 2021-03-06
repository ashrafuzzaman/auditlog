$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rails'
require 'bundler/setup'
Bundler.require

#require 'capybara/rspec'
require 'database_cleaner'
require 'active_record'
require 'rails_app/application'
require 'rspec/rails'
require 'shoulda/matchers'
require 'shoulda-callback-matchers'

autoload :ReservationCommissionReceivable, 'commission/app/models/reservation_commission_receivable'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end