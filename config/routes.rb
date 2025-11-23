Rails.application.routes.draw do
  get "parking_managers/show"
  get "dashboards/show"
  devise_for :parking_managers, controllers: {
    sessions: "parking_managers/sessions",
    registrations: "parking_managers/registrations"
  }
  resource :account, only: [ :show ], controller: "parking_managers", path: "profile", as: :profile
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  #
  authenticated :parking_manager do
    root to: "dashboards#show", as: :authenticated_root
    resource :dashboard, only: %i[show edit update], path: "/my_dashboard"
    get "dashboards", to: "dashboards#index", as: "dashboards_index"
  end

  unauthenticated :parking_manager do
    root to: redirect("/parking_managers/sign_in"), as: :unauthenticated_root
  end
 end
