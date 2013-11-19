class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || locale_from_browser || default_language
    if I18n.locale.to_s != session[:locale].to_s
      logger.debug "Locale changed from -#{session[:locale].to_s}- to -#{I18n.locale.to_s}-."
    end
    session[:locale] = I18n.locale.to_s
  end

  require 'ostruct'
  def current_user
    @current_user ||= OpenStruct.new(name: "John Smith", can_translate?: true)
  end
  helper_method :current_user

  private
    def locale_from_browser
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
end
