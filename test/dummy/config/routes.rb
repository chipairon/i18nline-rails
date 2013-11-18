Rails.application.routes.draw do

  mount I18nline::Engine => "/i18nline"

  get 'login', to: 'hello#login'

  root to: "hello#hello"

end
