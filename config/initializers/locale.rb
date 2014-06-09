require 'i18n/backend/active_record'
module I18nline
  class MyBackend < I18n::Backend::ActiveRecord
    Translation.table_name = "i18nline_translations"
    include I18n::Backend::ActiveRecord::Missing
    include I18n::Backend::Memoize
  end
end

# Some times part of the app is initialized but i18nline is not ready.
# This happens in 'rake assets:precompile', for instance.
begin
  # This check is needed to make possible to install migrations with
  # rake when there are other gems using I18n at setup before the
  # table is created.
  if ActiveRecord::Base.connection.table_exists? 'i18nline_translations'
    module I18n
      module Backend
        class Chain
          def available_locales
            I18nline::enabled_locales
          end

          module Implementation

            # This is the entry point to make the translation.
            # We need to override this method to store missing translations:
            # 1st backend is AR, if it misses then we want to store the translation
            # as missed, but if there is a default value or it is translated in other
            # backend, we want to store that value, instead of nil.
            def translate(locale, key, default_options = {})
              namespace = nil
              options = default_options.except(:default)
              final_translation = nil
              should_store_in_db = false

              backends.each do |backend|
                catched_value = catch(:exception) do
                  options = default_options if backend == backends.last
                  translation = backend.translate(locale, key, options)
                  if namespace_lookup?(translation, options)
                    namespace = translation.merge(namespace || {})
                  elsif !translation.nil?
                    final_translation = translation
                    break
                  end
                end
                if catched_value.class == MissingTranslation
                  should_store_in_db = true
                end
              end

              if final_translation.nil?
                final_translation = namespace
              end

              if should_store_in_db
                default_options[:default] = final_translation
                TRANSLATION_STORE.store_default_translations(locale, key, default_options)
              end

              return final_translation if final_translation
              throw(:exception, I18n::MissingTranslation.new(locale, key, options))
            end
          end

        end
      end
    end

    TRANSLATION_STORE = I18nline::MyBackend.new
    I18n.backend = I18n::Backend::Chain.new(TRANSLATION_STORE, I18n::Backend::Simple.new)
  end
rescue
  puts "I18nline not initiatied at this point."
end
