# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'bundler/setup'
require 'test/unit'
require 'mocha'
require 'test_declarative'
require 'rails'
require 'i18nline'
require 'byebug'
require_relative "../app/models/i18nline/redis_store.rb"

class I18n::TestCase < Test::Unit::TestCase
  def teardown
    super
    I18n.enforce_available_locales = nil
    I18n.available_locales = nil
    I18n.locale = nil
    I18n.default_locale = :en
    I18n.load_path = []
    I18n.backend = nil
  end

  # Ignore Test::Unit::TestCase failing if the test case does not contain any
  # test, otherwise it will blow up because of this base class.
  #
  # TODO: remove when test-unit is not used anymore.
  def default_test
    nil
  end

  protected

    def translations
      I18n.backend.instance_variable_get(:@translations)
    end

    def store_translations(locale, data)
      I18n.backend.store_translations(locale, data)
    end

    def locales_dir
      File.dirname(__FILE__) + '/test_data/locales'
    end
end
