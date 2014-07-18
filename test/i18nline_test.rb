require 'test_helper'

class I18nlineTest < I18n::TestCase
  def setup
    I18n.enforce_available_locales = nil
    I18n.available_locales = nil
    I18n.locale = nil
    I18n.default_locale = :en
    I18n.load_path = []
    I18n.available_locales = nil
    I18n.backend = nil
    tr_store = I18nline::RedisStore.new(I18nline.redis_options)
    I18n.backend = I18nline::MyBackend.new(tr_store, true)

    tr_store.redis_db.flushdb
    super
  end

  #test "lookup can return a hash" do
    #store_translations("xx", hash: { "a" => "b" })
    #assert_nothing_raised { I18n.t(:hash) }
  #end
  
  include I18n::Tests::Basics
  include I18n::Tests::Defaults
  include I18n::Tests::Interpolation
  include I18n::Tests::Link
  include I18n::Tests::Lookup
  include I18n::Tests::Pluralization

  include I18n::Tests::Localization::Date
  include I18n::Tests::Localization::DateTime
  include I18n::Tests::Localization::Time
end
