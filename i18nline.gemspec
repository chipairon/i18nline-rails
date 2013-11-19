$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "i18nline/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "i18nline"
  s.version     = I18nline::VERSION
  s.authors     = ["Rubén Díaz-Jorge Gil"]
  s.email       = ["rubendiazjorge@gmail.com"]
  s.homepage    = "http://github.com/elpulgardelpanda/i18nline"
  s.summary     = "Translation management engine for Rails applications"
  s.description = "Translation management engine for Rails applications"
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "jquery-rails"
  s.add_dependency "kaminari", "~> 0.14"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "byebug"
end
