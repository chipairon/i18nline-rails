namespace :i18nline do
  desc "If a key is found in a locale but not in other, add the translation to the locale missing it."
  task :add_missing_keys => :environment do
    I18n::Backend::ActiveRecord::Translation.find_each do |translation|
      I18n.available_locales.each do |a_locale|
        next if a_locale == translation.locale
        if I18n::Backend::ActiveRecord::Translation.where(key: translation.key, locale: a_locale).empty?
          puts "Adding missing translation key: #{a_locale}-#{translation.key} based on #{translation.locale}"
          I18n::Backend::ActiveRecord::Translation.create!(
            key: translation.key,
            locale: a_locale,
            value: nil,
            interpolations: translation.interpolations,
            is_proc: translation.is_proc
          )
        end
      end
    end
  end
end
