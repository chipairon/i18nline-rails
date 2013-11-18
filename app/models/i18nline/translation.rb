module I18nline
  class Translation < ActiveRecord::Base
    after_save :update_caches
    def update_caches
      TRANSLATION_STORE.reload!
    end
  end
end
