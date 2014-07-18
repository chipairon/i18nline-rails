require File.join(File.dirname(__FILE__), 'action_view_extension')
module I18nline
  class Railtie < Rails::Railtie
    initializer "i18nline.configure_rails_initialization" do |app|
      app.config.assets.precompile += %w(i18nline_to_host.js i18nline_to_host.css)

      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, I18nline::ActionViewExtension
      end

      # code to execute after the initializers of the host app are run:
      app.config.after_initialize do
        I18nline::TR_STORE = I18nline::RedisStore.new(I18nline.redis_options)
        I18n.backend = I18nline::MyBackend.new(I18nline::TR_STORE, true)

        # load translations from yaml files:
        # This makes also possible to pass pluralizations from Yaml files to
        # the real backend so it can store them in memory, as the key value store
        # cannot store Procs on bd.
        simple = SimpleInitializer.new
        simple.load_translations


      end
    end
  end
  class SimpleInitializer < I18n::Backend::Simple
    include I18n::Backend::Pluralization
    include I18n::Backend::Flatten

    # only store translation from simple to the real backend if they are new:
    def store_translations(locale, data, options = {})
      escape = options.fetch(:escape, true)
      flatten_translations(locale, data, escape, @subtrees).each do |key, value|
        # Pluralization rules come as Procs, that a key-value store cannot handle,
        # so we keep them in memory instead:
        if key == :'i18n.plural.rule'
          I18n.backend.send(:pluralizers)[locale] = value
        elsif key == :'i18n.plural.keys'
          I18n.backend.store_translations(locale, { key => value }, options)
          next
        elsif I18n.backend.store["#{locale}.#{key}"].nil?
          I18n.backend.store_translations(locale, data, options)
        end
      end
    end

  end
end
