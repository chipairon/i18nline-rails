module I18nline
  class ApplicationController < ActionController::Base
    before_filter :check_authenticated_user

    private

      def check_authenticated_user
        unless(get_current_user and get_current_user.try(I18nline.can_translate_method))
          redirect_to I18nline::login_route, error: "You need to login first"
        end
      end

      def get_current_user
        I18nline.current_user ||= send I18nline.current_user_method
      end

  end
end
