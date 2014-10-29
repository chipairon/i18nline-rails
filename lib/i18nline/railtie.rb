require File.join(File.dirname(__FILE__), 'action_view_extension')
module I18nline
  class Railtie < Rails::Railtie
    initializer "i18nline.configure_rails_initialization" do |app|
      app.config.assets.precompile += %w(i18nline_to_host.js i18nline_to_host.css)
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, I18nline::ActionViewExtension
      end
    end

    rake_tasks do
      load "tasks/i18nline_tasks.rake"
    end
  end
end
