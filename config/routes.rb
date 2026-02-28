Rails.application.routes.draw do
  devise_for :admin, path: "admin", path_names: { sign_in: "login" }, controllers: {
    sessions: "admin/devise/sessions"
  }

  namespace :admin do
    root to: "dashboards#show"
    resources :parking_managers, only: %i[ index show ] do
      member do
        get :contractors, to: "parking_manager_contractors#index", as: :contractors
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
end
