$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auditlog/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auditlog"
  s.version     = Auditlog::VERSION
  s.author      = "A.K.M. Ashrafuzzaman"
  s.email       = ["ashrafuzzaman.g2@gmail.com"]
  s.homepage    = "https://github.com/ashrafuzzaman/auditlog"
  s.summary     = "Auditlog is ruby gem to track rails model changes"
  s.description = "Rails gem to track active record model changes. Allows user to track action based model changes."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3"
  s.add_dependency "request_store", '>= 1.0.5'
  s.license = 'MIT'
  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rake', ['>= 0']
  s.add_development_dependency 'rspec', ['>= 0']
  s.add_development_dependency 'rspec-rails', ['>= 0']
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'database_cleaner', ['>= 1.2.0']
end