require 'i18n/backend/active_record'
module I18nline
  class MyBackend < I18n::Backend::ActiveRecord
    Translation.table_name = "i18nline_translations"
    include I18n::Backend::ActiveRecord::Missing
    include I18n::Backend::Memoize

    def available_locales
      I18nline::enabled_locales
    end
  end
end
TRANSLATION_STORE = I18nline::MyBackend.new
I18n.backend = I18n::Backend::Chain.new(TRANSLATION_STORE, I18n::Backend::Simple.new)
module I18n
  class JustRaiseExceptionHandler < ExceptionHandler
    def call(exception, locale, key, options)
      if exception.is_a?(MissingTranslation)
        TRANSLATION_STORE.store_default_translations(locale, key, options)
      end
      super
    end
  end
end
I18n.exception_handler = I18n::JustRaiseExceptionHandler.new
