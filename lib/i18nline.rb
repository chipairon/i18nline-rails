require "i18nline/engine"
require 'i18nline/railtie' if defined?(Rails)
require 'kaminari'

module I18nline

  ## CONFIGURATION OPTIONS:

  mattr_accessor :current_user_method
  @@current_user_method = "current_user"

  mattr_accessor :can_translate_method
  @@can_translate_method = "can_translate?"

  mattr_accessor :login_route
  @@login_route = "/login"

  mattr_accessor :enabled_locales
  @@enabled_locales = nil

  mattr_accessor :redis_options
  @@redis_options = { db: 8 }

  def self.setup
    yield self
  end

  class MyBackend < I18n::Backend::KeyValue
    include I18n::Backend::Pluralization
    # TODO: think how to invalidate cache/memoize
    #include I18n::Backend::Memoize

    module Implementation
      def available_locales
        I18nline::enabled_locales || super
      end

      def pluralization_keys(locale)
        @store["#{locale}.i18n.plural.keys"] || [:zero, :one, :other]
      end

      def translate(locale, key, options = {})
        default_option = options[:default]
        flattenned_key = normalize_flat_keys(locale, key, options[:scope], options[:separator])
        final_value = nil
        catched_value = catch(:exception) do
          final_value = super(locale, key, options)
        end
        if catched_value.class == I18n::MissingTranslation
          final_value = "translation missing: #{locale}.#{key}"
          store_in_available_locales(locale, flattenned_key, nil, options)
          throw(:exception, I18n::MissingTranslation.new(locale, key, options))
        elsif default_option
          if options[:count] == nil && @store["#{locale}.#{flattenned_key}"].nil?
            store_in_available_locales(locale, flattenned_key, default_option, options)
          # TODO: I don't now if I should integrate this back. Need to find a failing test:
          # The condition is not right in its current form.
          #elsif options[:count] && @store["#{locale}.#{flattenned_key}.#{last_used_pluralization_key}"].nil?)
            #store_in_available_locales(locale, flattenned_key, default_option, options)
          end
          if final_value.is_a?(Array) && ActiveSupport::JSON.encode(final_value) == ActiveSupport::JSON.encode(options[:default])
            final_value = default(locale, flattenned_key, options[:default], options)
          end
        end
        if final_value.nil?
          final_value = "translation missing: #{locale}.#{key}"
        end
        final_value
      end

      def store_in_available_locales(triggering_locale, key, value, options)
        options_for_store = options.merge({ escape: false })
        options_for_store.delete(:default)
        count = options[:count]

        I18n.available_locales.each do |a_locale|
          I18n.with_locale(a_locale) do

            if count
              hash_with_pluralizations = {}
              pluralization_keys(a_locale).each { |a_key|
                hash_with_pluralizations[a_key.to_sym] = value
              }
              store_translations(a_locale, { key => hash_with_pluralizations }, options_for_store)
            elsif a_locale.to_s == triggering_locale.to_s
              # always store for the triggering locale
              store_translations(a_locale, { key => value }, options_for_store)
            end
          end
        end
      end

      #def store_translations(locale, data, options = {})
        #is_a_pluralization_rule = false
        #escape = options.fetch(:escape, true)
        #flatten_translations(locale, data, escape, @subtrees).each do |key, value|
          ##key = "#{locale}.#{key}"
          ## Pluralization rules come as Procs, that a key-value store cannot handle,
          ## so we keep them in memory instead:
          #if key == :'i18n.plural.rule'
            #is_a_pluralization_rule = true
            #pluralizers[locale] = value
          #end
        #end
        #unless is_a_pluralization_rule
          #return super
        #end
      #end

      def lookup(locale, key, scope = [], options = {})
        if options[:count]
          values = {}
          pluralization_keys(locale).each do |pl_key|
            value = @store["#{locale}.#{key}.#{pl_key}"]
            value = ActiveSupport::JSON.decode(value) if value
            values[pl_key.to_sym] = value
          end
          if values.values.select{ |v| !v.nil? }.any?
            return values
          else
            return nil
          end
        else
          return super
        end
      end
    end
    include Implementation
  end
end

