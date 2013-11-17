$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auditlog/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auditlog"
  s.version     = Auditlog::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Auditlog."
  s.description = "TODO: Description of Auditlog."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "request_store"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-mocks'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'awesome_print'
end
