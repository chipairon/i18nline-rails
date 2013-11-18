# Use this setup block to configure all options available in i18nline.
I18nline.setup do |config|

  # A helper method available in your views so we can ask if there is a current user.
  config.current_user_method = "current_user"

  # A method your current_user has to respond to affirmatively to be able to
  # interact with i18nline administration features, like inline markers and
  # translation management views.
  # This method will be tried in the instance returned by the 'current_user' helper
  # specified above: current_user.can_translate?
  config.can_translate_method = "can_translate?"

  # A route available in your application to redirect the user to login
  # when he tries to access to protected views. This route should be
  # available on your 'rake routes'.
  config.login_route = "/login"

  # Missing translations will be generated for this locales.
  config.enabled_locales = %w(en es it pt)
end
