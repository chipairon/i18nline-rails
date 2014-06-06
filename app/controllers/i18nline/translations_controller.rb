require_dependency "i18nline/application_controller"

module I18nline
  class TranslationsController < ApplicationController
    before_filter :set_translation, only: [:show, :edit, :update, :destroy]

    def find_by_key
      tokens = params[:key].split(".")
      locale_at_inline_key = tokens.delete_at(0)
      key = tokens.join(".")
      translations = Translation.where(key: key)
      if translations.none?
        redirect_to :root, error: "Something went wrong. No translations found." and return
      end

      # This is needed to preserve nil values
      # otherwise 'update action' receives ""
      # and stores an empty string
      translations.each do |a_tr|
        if a_tr.value.nil?
          a_tr.make_nil = true
        end
      end

      require 'ostruct'
      @tr_set = OpenStruct.new(
        translations: translations,
        key: key,
        locale_at_inline_key: locale_at_inline_key,
        interpolations: translations.first.interpolations.to_s,
        is_proc: translations.first.is_proc
      )

      @should_show_yaml_warning = check_yaml_warning(translations)

      render "edit_key" and return
    end

    # GET /translations
    def index
      q = Translation.search_key(params[:search_key])
        .search_value(params[:search_value])
        .in_locale(params[:search_locale])
        .not_translated(params[:search_not_translated])
        .blank_value(params[:search_blank_value])
      @translations = q.page(params[:page]).per(25)
    end

    def update_key_set
      unless params[:tr_set]
        redirect_to :root, error: "Something went wrong. No translations found." and return
      end
      is_proc = params[:tr_set][:is_proc]
      params[:tr_set][:translation].each do |translation|
        db_translation = Translation.find(translation.first)
        if db_translation
          db_translation.value = convert_to_object(translation.last[:value])
          db_translation.is_proc = is_proc
          if translation.last[:make_nil].presence == "1"
            # it is likely that if value was nil and now is not, 'make_nil' has been left marked
            # as a mistake, so in that case we ignore it and apply the new value:
            unless db_translation.value_changed? && db_translation.value_was.nil? && db_translation.value.present?
              db_translation.value = nil
            end
          end
          if db_translation.changed?
            db_translation.save
          end
        end
      end
      redirect_to :translations, notice: "Update successful."
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_translation
        @translation = Translation.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def translation_params
        params.require(:translation).permit(:value, :is_proc, :make_nil)
      end

      def convert_to_object(value)
        # gsub part is keeping integrity of serialized objects, such as arrays:
        result = value.gsub("\r\n", "\n")
        if value.start_with?("---")
          begin
            result = YAML::load(value)
          rescue Exception => exception
            logger.debug "I18nline: Exception found trying to  parse yaml to convert translation value to object:"
            logger.debug exception
          end
        end
        result
      end

      def check_yaml_warning(translations)
        should_show = false
        if I18nline.show_yaml_warning
          if translations.select{|tt| tt.value and tt.value.class != String}.any?
            should_show = true
          end
        end
        should_show
      end
  end
end
