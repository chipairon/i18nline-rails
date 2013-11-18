module I18nline
  class ApplicationController < ActionController::Base
    before_action :check_authenticated_user

    private

    def check_authenticated_user
      unless(I18nline.current_user and I18nline.current_user.try(I18nline.can_translate_method))
        redirect_to I18nline::login_route, error: "You need to login first"
      end
    end
  end
end
