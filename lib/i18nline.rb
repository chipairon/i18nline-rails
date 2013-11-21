require "i18nline/engine"
require 'i18nline/railtie' if defined?(Rails)
require 'kaminari'

module I18nline

  ## CONFIGURATION OPTIONS:

  mattr_accessor :current_user_method
  @@current_user_method = "current_user"

  mattr_accessor :can_translate_method
  @@can_translate_method = "can_translate?"

  mattr_accessor :login_route
  @@login_route = "/login"

  mattr_accessor :enabled_locales
  @@enabled_locales = %w(en es it)

  mattr_accessor :show_yaml_warning
  @@show_yaml_warning = true

  def self.setup
    yield self
  end

  private
  mattr_accessor :current_user
  @@current_user ||= nil

end
