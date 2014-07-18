require_dependency "i18nline/application_controller"
require 'ostruct'

module I18nline

  # needed to contruct the form on edit translations:
  Tr = Struct.new(:locale, :key, :value, :make_nil) do
    def to_s
      "#{locale}.#{key}"
    end
  end

  class TranslationsController < ApplicationController

    # GET /translations
    def index
      tr_found = TR_STORE.search(
        search_value: params[:search_value],
        search_key: params[:search_key],
        search_locale: params[:search_locale],
        not_translated: params[:not_translated],
        blank_value: params[:blank_value]
      )
      @translations = Kaminari.paginate_array(tr_found).page(params[:page]).per(25)
    end

    def find_by_key
      tokens = params[:key].split(".")
      locale_at_inline_key = tokens.delete_at(0)
      key = tokens.join(".")
      pluralized = TR_STORE.key? "#{locale_at_inline_key}.#{key}.other"

      translations = []
      I18n.available_locales.map do |cur_locale|
        # If it is a pluralized key:
        if pluralized
          I18n.backend.pluralization_keys(cur_locale).each do |pl_key|
            value = TR_STORE["#{cur_locale}.#{key}.#{pl_key}"]
            if value
              value = ActiveSupport::JSON.decode(value)
            end
            tr_instance = Tr.new(
              cur_locale,
              "#{key}.#{pl_key}",
              value,
              # This is needed to preserve nil values
              # otherwise 'update action' receives ""
              # and stores an empty string:
              value.nil?
            )
            translations << tr_instance
          end
        else
          value = TR_STORE["#{cur_locale}.#{key}"]
          if value
            value = ActiveSupport::JSON.decode(value)
          end
          tr_instance = Tr.new(
            cur_locale,
            key,
            value,
            # This is needed to preserve nil values
            # otherwise 'update action' receives ""
            # and stores an empty string:
            value.nil?
          )
          translations << tr_instance
        end
      end
      if translations.none?
        redirect_to :root, error: "Something went wrong. No translations found." and return
      end

      @tr_set = OpenStruct.new(
        translations: translations,
        key: key,
        pluralized: pluralized,
        locale_at_inline_key: locale_at_inline_key,
      )

      render "edit_key" and return
    end


    def update_key_set
      unless params[:tr_set]
        redirect_to :root, error: "Something went wrong. No translations found." and return
      end
      params[:tr_set][:translation].each do |translation|
        key_segments = translation.first.split(".")
        locale = key_segments.shift
        key_without_locale = key_segments.join(".")
        db_value = I18n.backend.send(:lookup, locale, key_without_locale)
        if db_value
          new_value = translation.last[:value]
          if translation.last[:make_nil].presence == "1"
            # it is likely that if value was nil and now is not, 'make_nil' has been left marked
            # as a mistake, so in that case we ignore it and apply the new value. -> this means that if this
            # is the case, we don't mark it as nil.
            # The other case we override is if 'make nil' is marked and the db value is the same as the new value,
            # it is likely that they forgot to clear the new value, but as they marked 'make nil', we will make it nil.
            if !new_value.present? or db_value == new_value
              new_value = nil
            end
          end
          if db_value != new_value
            # if is a part of a Hash, we need to store it as part of the hash,
            # because if the stored translation is:
            #   { mail: { one: "one mail", other: "%{count} mails" } }
            #   Then:
            #   I18n.t("mail", count: 1) # => one mail
            #   But when updating key as "mail.one" = "some value"
            #   A new translation will be added for "mail.one" instead of updating the corresponding hash.
            #   Then the lookup of "mail.one" will return the value from the hash.
            # This code is fixing that, updating the hash when appropriate:
            #
            last_key_segment = key_without_locale.split(".").last.to_sym
            parent_hash_key = key_without_locale.split(".")[0..-2].join(".")
            parent_hash = I18n.backend.send(:lookup, locale, parent_hash_key)
            if parent_hash.is_a?(Hash) and parent_hash.keys.include?(last_key_segment)
              parent_hash[last_key_segment] = new_value
              I18n.backend.store_translations(locale, { parent_hash_key => parent_hash }, :escape => false)
            else
              I18n.backend.store_translations(locale, { key_without_locale => new_value }, :escape => false)
            end
          end
        end
      end
      redirect_to :translations, notice: "Update successful."
    end

  end
end
