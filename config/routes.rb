Rails.application.routes.draw do
  devise_for :admin, path: "admin", path_names: { sign_in: "login" }, controllers: {
    sessions: "admin/devise/sessions"
  }

  namespace :admin do
    root to: "dashboards#show"
    resources :parking_managers, only: %i[ index show ]
    resources :contractors, only: %i[ index show ] do
      member do
        get :contractors
      end
    end
  end

  get "contractors/new"
  get "parking_managers/show"
  get "dashboards/show"
  devise_for :parking_managers, controllers: {
    sessions: "parking_managers/sessions",
    registrations: "parking_managers/registrations"
  }

  resource :account, only: [ :show ], controller: "parking_managers", path: "profile", as: :profile

  resources :parking_lots, only: %i[ new create index update edit destroy ] do
    resources :parking_spaces, only: %i[ new create index show edit update destroy ]
  end

  resources :contractors, only: %i[ new create show index edit update destroy ] do
    resources :contract_parking_spaces, only: %i[ new create index edit update ]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  devise_scope :parking_manager do
    authenticated :parking_manager do
      root to: "dashboards#show", as: :my_dashboard_root
      resource :dashboard, only: %i[show edit update], path: "/my_dashboard"
    end

    unauthenticated :parking_manager do
      root to: redirect("/parking_managers/sign_in"), as: :parking_manager_login_root
    end
  end
end
