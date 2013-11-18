module I18nline
  class Translation < ActiveRecord::Base
    after_save :update_caches
    attr_accessor :make_nil
    serialize :value
    serialize :interpolations, Array

    def update_caches
      TRANSLATION_STORE.reload!
    end
  end
end
