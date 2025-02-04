Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "switch_language/:locale", to: "application#switch_language", as: :switch_language
    resources :jobs
    resources :companies
    resources :users do
      resources :user_profiles do
        member do
          delete :remove_skill
          post :add_skill
        end
      end
      resources :user_projects
      resources :user_social_links
    end
    resources :applications, only: %i(create show update)
    resources :notifications, only: [] do
      member do
        patch :mark_as_read
      end
      collection do
        patch :mark_all_as_read
      end
    end

    get "home/index"
    root "home#index"
    devise_for :users,
               path: "",
               path_names: {sign_in: "login", sign_out: "logout", sign_up: "signup"},
               controllers: {
                sessions: "users/sessions",
                registrations: "users/registrations",
                passwords: "users/passwords",
               }

    namespace :enterprise do
      devise_for :users,
               path: "",
               path_names: {sign_in: "login", sign_out: "logout"},
               controllers: {
                sessions: "enterprise/sessions",
                passwords: "enterprise/passwords",
               }
      root "dashboard#index"
      resources :jobs
      resources :applications do
        member do
          patch :update_status
        end
        resources :interview_processes, only: %i(create update destroy)
      end
    end

    namespace :admin do
      devise_for :users,
               path: "",
               path_names: {sign_in: "login", sign_out: "logout"},
               controllers: {
                sessions: "admin/sessions",
                passwords: "admin/passwords",
               }
      root "dashboard#index"
      resources :jobs, only: %i(update)
    end

    get "/translations/:locale", to: "translations#show"
  end
end
