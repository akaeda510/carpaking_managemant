Rails.application.routes.draw do
  namespace :admin do
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    root to: "dashboards#index"
    resources :parking_managers, only: %i[ index show ]

    resources :contractors, only: %i[ index show ]
    resources :parking_lots, only: %i[ index show ], shallow: true do
      resources :parking_areas, only: %i[ show ], shallow: true do
        resources :parking_spaces, only: %i[ show ], shallow: true do
          resources :contracts, only: %i[ index ], module: :parking_spaces
        end
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

  resources :devices, only: [] do
    collection do
      get "verify/:device_token", to: "parking_managers/devices#verify", as: :verify
    end

    member do
      post "resend_email", to: "parking_managers/devices#resend_email", as: :resend_email_parking_managers
    end
  end

  devise_scope :parking_manager do
    get "parking_managers/sessions/wait_verification", to: "parking_managers/sessions#wait_verification", as: :wait_verification
  end

  resources :parking_lots, only: %i[ new create index update edit destroy ] do
    resources :parking_areas, only: %i[ new create index edit update destroy ] do
      resources :parking_spaces, only: %i[ new create index show edit update destroy ]
    end
  end

  resources :contractors, only: %i[ new create show index edit update destroy ] do
    resources :contract_parking_spaces, only: %i[ new create index edit update ]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  devise_scope :parking_manager do
    authenticated :parking_manager do
      root to: "dashboards#show", as: :my_dashboard_root
      resource :dashboard, only: %i[show edit update], path: "/my_dashboard"
    end

    unauthenticated :parking_manager do
      root to: redirect("/parking_managers/sign_in"), as: :parking_manager_login_root
    end
  end

  Rails.application.routes.draw do
    mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  end
end
