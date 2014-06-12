module I18nline
  module ActionViewExtension
    extend ActiveSupport::Concern

    included do
      def current_user_can_translate?
        current_user = send I18nline.current_user_method

        if current_user and current_user.try(I18nline.can_translate_method)
          return true
        end

        false
      end

      # Replace the translation key with a 'span'. The class tells if it is missing or not,
      # and the title contains the key
      def ti(*args)
        translation = ActionController::Base.helpers.translate(*args)

        if current_user_can_translate?
          result = nil
          if translation.to_s.include?("translation_missing")
            result = translation.gsub("translation missing: ", "")
          else
            result = content_tag(:span, translation, class: 'translation_found', title: "#{I18n.locale}.#{args.first}")
          end

          return result.html_safe
        else
          return sanitize_translation_missing(translation)
        end
      end
    end

    def i18nline_assets_inclusion_tag
      if current_user_can_translate?
        assets = ""
        assets << i18nline_host_styles << "\n"
        assets << i18nline_host_javascripts << "\n"
        assets.html_safe
      end
    end

    private

      # Javascripts that will be loaded on host application:
      def i18nline_host_javascripts
        javascript_include_tag("i18nline_to_host.js")
      end

      # Css that will be loaded on host application:
      def i18nline_host_styles
        stylesheet_link_tag("i18nline_to_host.css")
      end

      def sanitize_translation_missing(translation)
        translation_missing_match = translation.match(/<span class="translation_missing".*>(.*)<\/span>/)

        return translation_missing_match[1] if translation_missing_match

        translation
      end
  end
end
