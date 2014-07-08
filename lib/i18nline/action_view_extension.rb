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
        translation = I18n.t(*args)
        translation_missing = translation.include?("translation missing:")
        if translation_missing
          translation = args[0].split(".").last.to_s.titleize
        end
        key = args[0]
        if key.end_with? "_html"
          translation = translation.html_safe
        end
        if current_user_can_translate?
          if translation_missing
            result = content_tag(:span, translation, class: 'translation_missing', title: "#{I18n.locale}.#{args.first}")
          else
            result = content_tag(:span, translation, class: 'translation_found', title: "#{I18n.locale}.#{args.first}")
          end

          return result.html_safe
        else
          return translation
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
  end
end
