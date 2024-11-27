Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "switch_language/:locale", to: "application#switch_language", as: :switch_language
    get "home/index"
    root "home#index"
  end
end
