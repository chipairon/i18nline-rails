module I18nline
  module ActionViewExtension
    extend ActiveSupport::Concern

    def i18nline_assets_inclusion_tag
      assets = ""
      assets << i18nline_host_styles << "\n"
      assets << i18nline_host_javascripts << "\n"
      assets.html_safe
    end

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
