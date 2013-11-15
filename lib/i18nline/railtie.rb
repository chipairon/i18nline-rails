require File.join(File.dirname(__FILE__), 'action_view_extension')
module I18nline
  class Railtie < Rails::Railtie
    initializer "i18nline.configure_rails_initialization" do
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, I18nline::ActionViewExtension
      end
    end
  end
end
