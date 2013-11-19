module I18nline
  class Translation < ActiveRecord::Base
    after_save :update_caches
    attr_accessor :make_nil
    serialize :value
    serialize :interpolations, Array

    default_scope { order("created_at desc") }

    def self.not_translated(apply_this = "1")
      if apply_this.present?
        where("value is null")
      else
        scoped
      end
    end

    def self.blank_value(apply_this = "1")
      if apply_this.present?
        #value is serialized so searching for empty is complicated:
        where("value like ?", "".to_yaml)
      else
        scoped
      end
    end

    def self.in_locale(locale)
      if locale.present?
        where("locale = ?", locale)
      else
        scoped
      end
    end

    def self.search_key(to_search)
      if to_search.present?
        where("key like ?", "%#{to_search}%")
      else
        scoped
      end
    end

    def self.search_value(to_search)
      if to_search.present?
        where("value like ?", "%#{to_search}%")
      else
        scoped
      end
    end

    def update_caches
      TRANSLATION_STORE.reload!
    end
  end
end
