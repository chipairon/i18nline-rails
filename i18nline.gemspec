$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "i18nline/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "i18nline"
  s.version     = I18nline::VERSION
  s.authors     = ["Rubén Díaz-Jorge Gil"]
  s.email       = ["rubendiazjorge@gmail.com"]
  s.homepage    = "https://github.com/Chipairon"
  s.summary     = "Inline translations"
  s.description = "Inline translations for I18n using fast-gettext as a translations backend."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  #s.add_dependency 'gettext_i18n_rails'

  s.add_development_dependency "sqlite3"
end
