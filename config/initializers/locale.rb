require 'i18n/backend/active_record'
module I18n
  class JustRaiseExceptionHandler < ExceptionHandler
    def call(exception, locale, key, options)
      if exception.is_a?(MissingTranslation)
        my_backend_instance = I18n::backend.backends.select{|b| b.class == I18nline::MyBackend}.first
        if my_backend_instance
          my_backend_instance.store_default_translations(locale, key, options)
        end
      end
      super
    end
  end
end
I18n.exception_handler = I18n::JustRaiseExceptionHandler.new
module I18nline
  class MyBackend < I18n::Backend::ActiveRecord
    Translation.table_name = "i18nline_translations"
    include I18n::Backend::ActiveRecord::Missing
  end
end
I18n.backend = I18n::Backend::Chain.new(I18nline::MyBackend.new, I18n::Backend::Simple.new)
