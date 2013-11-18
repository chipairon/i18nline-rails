require_dependency "i18nline/application_controller"

module I18nline
  class TranslationsController < ApplicationController
    before_action :set_translation, only: [:show, :edit, :update, :destroy]

    def find_by_key
      tokens = params[:key].split(".")
      locale_at_inline_key = tokens.delete_at(0)
      key = tokens.join(".")
      translations = Translation.where("key = ?", key)
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

      render "edit_key" and return
    end

    # GET /translations
    def index
      @translations = Translation.all
    end

    # GET /translations/1/edit
    def edit
    end

    def update_key_set
      unless params[:tr_set]
        redirect_to :root, error: "Something went wrong. No translations found." and return
      end
      is_proc = params[:tr_set][:is_proc]
      params[:tr_set][:translation].each do |translation|
        db_translation = Translation.find(translation.first)
        if db_translation
          db_translation.value = translation.last[:value]
          db_translation.is_proc = is_proc
          if translation.last[:make_nil].presence == "1"
            db_translation.value = nil
          end
          if db_translation.changed?
            db_translation.save
          end
        end
      end
      redirect_to :translations, notice: "Update successful."
    end

    # PATCH/PUT /translations/1
    def update
      if translation_params[:make_nil].presence == "1"
        params[:translation][:value] = nil
      end
      if @translation.update(translation_params)
        redirect_to @translation, notice: 'Translation was successfully updated.'
      else
        render action: 'edit'
      end
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
  end
end
