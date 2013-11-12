Rails.application.routes.draw do

  mount I18nline::Engine => "/i18nline"


  root to: "hello#hello"

end
