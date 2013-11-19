module I18nline
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy i18nline default files"
      source_root File.expand_path('../templates', __FILE__)

      def copy_config
        template "config/initializers/i18nline.rb"
      end

      def create_migrations
        migration_template 'migrations/create_i18nline_translations.rb', 'db/migrate/create_i18nline_translations.rb'
      end
    end
  end
end
