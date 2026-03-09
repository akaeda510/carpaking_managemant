Rails.application.routes.draw do
  namespace :admin do
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    root to: "dashboards#index"
    resources :parking_managers, only: %i[ index show ] do
      resources :contractors, only: %i[ index show ], shallow: true
    end
    resources :parking_lots, only: %i[ index show ], shallow: true do
      resources :parking_space, only: %i[ index ], shallow: true
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
    resources :parking_areas, only: %i[ new create index edit update destroy ] do
      resources :parking_spaces, only: %i[ new create index show edit update destroy ]
    end
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
