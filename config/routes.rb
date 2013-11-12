I18nline::Engine.routes.draw do
  resources :translations
  root to: "translations#index"
end
