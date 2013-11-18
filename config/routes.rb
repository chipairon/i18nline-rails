I18nline::Engine.routes.draw do
  resources :translations
  get "find_by_key", to: "translations#find_by_key"
  put "update_key_set", to: "translations#update_key_set"
  root to: "translations#index"
end
