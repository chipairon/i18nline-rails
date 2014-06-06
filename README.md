#i18nline

Translation management engine for Rails applications.

## What i18nline does


## Installation

1. Add i18nline to your Gemfile: `$ gem 'i18nline-rails'`
1b. Optionally install [rails-i18n](https://github.com/svenfuchs/rails-i18n) for some nice default translations: `$ gem 'rails-i18n'`jj
2. Run bundle: `$ bundle`
3. Copy pending migrations: `$ rake i18nline:install:migrations`
4. Copy initialization files: `$ rails generate i18nline:install`
5. Run migrations: `$ rake db:migrate`
6. Fill the required fields in `config/initializers/i18nline.rb`
7. Add a reference to i18nline assets to your application layout file: `<%= i18nline_assets_inclusion_tag %>`
8. Mount the engine adding this line to your routes.rb file: `mount I18nline::Engine => "/i18nline"`
9. Make sure i18n fallbacks are disabled if you want your translators to have access to "inline translation". In environtments/production.rb (and others) make sure: `config.i18n.fallbacks = false`
10. Restart the server

If everything is right, users who can translate as specified in the initilizer file will
see red inline marks on missing translations on views. 

Right clicking an inline mark will open a translation management view for that specific key.

A translation dashboard will be available to translators at `/i18nline`.

#### Note on locale tracking
Your application should keep track of the locale that is asked by the user.
A basic implementation of this in you application controller could look like this:
```
  before_action :set_locale

  def set_locale
    previous_locale = session[:locale] || I18n.locale.to_s
    I18n.locale = params[:locale] || session[:locale] || locale_from_browser || default_language
    if I18n.locale.to_s != session[:locale].to_s
      logger.debug "Locale changed from -#{session[:locale].to_s}- to -#{I18n.locale.to_s}-."
      unless I18n.available_locales.include? I18n.locale.to_s
        logger.debug "-#{I18n.locale.to_s}- is not included in available locales. Changing back to locale -#{previous_locale}-."
        I18n.locale = previous_locale
      end
    end
    session[:locale] = I18n.locale.to_s
  end

  private
    def locale_from_browser
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end


```

You can learn more about it here: http://guides.rubyonrails.org/i18n.html#setting-and-passing-the-locale

## Configuration
You need to provide some configuration options so i18nline can work. They configuration file is located at `your_app_root/config/initializers/i18nline.rb`.

## Advanced topics
Fallbacks are already done by I18n, but show how to use them here.

Cache abilitation already done by i18n, but show how to set it here.

## How to contribute

* Make your best effort to follow this guidelines:
    * https://github.com/thoughtbot/guides/tree/master/style#formatting
    * https://github.com/thoughtbot/guides/tree/master/style#ruby
    * https://github.com/thoughtbot/guides/tree/master/code-review
    * https://github.com/thoughtbot/guides/tree/master/best-practices
* Fork this repo.
* Create feature branch with a meaningful name in your fork.
* Make sure it works before starting your changes:

        $ bundle
        $ rake db:setup
        $ rake db:migrate
        $ rake
        $ cd test/dummy
        $ rails server
        
* Make your changes.
* Add tests to /i18nline_root/spec/*
* Add tests to /i18nline_root/test/dummy/spec/* to make a point for your changes when we review the pull request.
* Make sure all tests pass.
* Make your pull request.

## Contributors
https://github.com/Chipairon/i18nline/graphs/contributors


This project rocks and uses MIT-LICENSE.
