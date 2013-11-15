require_dependency "i18nline/application_controller"

module I18nline
  class TranslationsController < ApplicationController
    before_action :set_translation, only: [:show, :edit, :update, :destroy]

    def find_by_key
      begin
        tokens = params[:key].split(".")
        locale = tokens.delete_at(0)
        key = tokens.join(".")
        @translations = Translation.where("key = ?", key)
        render "index" and return
      rescue
        redirect_to :root and return
      end
    end

    # GET /translations
    def index
      @translations = Translation.all
    end

    # GET /translations/1
    def show
    end

    # GET /translations/new
    def new
      @translation = Translation.new
    end

    # GET /translations/1/edit
    def edit
    end

    # POST /translations
    def create
      @translation = Translation.new(translation_params)

      if @translation.save
        redirect_to @translation, notice: 'Translation was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /translations/1
    def update
      if @translation.update(translation_params)
        redirect_to @translation, notice: 'Translation was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /translations/1
    def destroy
      @translation.destroy
      redirect_to translations_url, notice: 'Translation was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_translation
        @translation = Translation.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def translation_params
        params.require(:translation).permit(:locale, :key, :value, :interpolations, :is_proc)
      end
  end
end
