module I18nline
  require 'redis'
  class RedisStore
    attr_accessor :redis_db
    attr_accessor :make_nil

    def initialize(args = {})
      @redis_db = Redis.new(args)
    end

    # Get a key
    def [](key)
      @redis_db[key]
    end

    # Set a key
    def []=(key, val)
      @redis_db[key] = val
    end

    # Get all keys
    def keys
      @redis_db.keys
    end

    def key?(a_key)
      @redis_db.exists a_key
    end

    #default_scope { self.scoped.order("created_at desc") }

    def not_translated(apply_this = "1")
      if apply_this.present?
        where("(value is null or value = '--- \n...\n')")
      else
        self.scoped
      end
    end

    def blank_value(apply_this = "1")
      if apply_this.present?
        #value is serialized so searching for empty is complicated:
        where("value like ?", "".to_yaml)
      else
        self.scoped
      end
    end

    def in_locale(locale)
      if locale.present?
        where("locale = ?", locale)
      else
        self.scoped
      end
    end

    def search_key(to_search)
    end

    def search_value(to_search)
      if to_search.present?
        where("value like ?", "%#{to_search}%")
      else
        self.scoped
      end
    end

    def search(params = {})
      search_value = params[:search_value].to_s
      search_key = params[:search_key].to_s
      locale = params[:search_locale]
      locale_filter = "#{locale}." if locale
      not_translated = !!params[:not_translated]
      blank_value = !!params[:blank_value]

      keys = @redis_db.keys "#{locale_filter}*#{search_key}*"
      return keys
      # TODO: continue with more filters, like 'value', blank, and not translated
      #keys.each do |key|
        #if not_translated
          #val = @redis_db[key]

      #results
    end
  end
end
