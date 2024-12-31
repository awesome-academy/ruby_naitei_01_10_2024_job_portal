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
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    namespace :enterprise do
      get "/login", to: "sessions#new"
      post "/login", to: "sessions#create"
      get "/logout", to: "sessions#destroy"
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
      get "/login", to: "sessions#new"
      post "/login", to: "sessions#create"
      get "/logout", to: "sessions#destroy"
      root "dashboard#index"
      resources :jobs, only: %i(update)
    end
  end
end
