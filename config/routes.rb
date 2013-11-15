I18nline::Engine.routes.draw do
  resources :translations
  get "find_by_key", to: "translations#find_by_key"
  root to: "translations#index"
end
