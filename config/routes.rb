Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "switch_language/:locale", to: "application#switch_language", as: :switch_language
    resources :jobs, only: [:index]
    get "home/index"
    root "home#index"
  end
end
