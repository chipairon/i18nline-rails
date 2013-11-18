#i18nline

Translation management engine for Rails applications.

## What i18nline does


## Installation

1. Add i18nline to your Gemfile: `$ gem 'i18nline'`
2. Run bundle: `$ bundle`
3. Copy initialization files: `$ rails generate i18nline:install`
4. Run migration to create the translation table: `$ rake db:migrate`
5. Fill the required fields in `config/initializers/i18nline.rb`
6. Add a reference to i18nline assets to your application layout file: `<%= i18nline_assets_inclusion_tag %>`
7. Mount the engine adding this line to your routes.rb file: `mount I18nline::Engine => "/i18nline"`
8. Restart the server

If everything is right, users who can translate as specified in the initilizer file will
see red inline marks on missing translations on views. 

Right clicking an inline mark will open a translation management view for that specific key.

A translation dashboard will be available to translators at `/i18nline`.

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
* Make your changes.
* Add tests to /i18nline_root/spec/*
* Add tests to /i18nline_root/test/dummy/spec/* to make a point for your changes when we review the pull request.
* Make sure all tests pass.
* Make your pull request.

## Contributors
https://github.com/Chipairon/i18nline/graphs/contributors


This project rocks and uses MIT-LICENSE.
