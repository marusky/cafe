Rails.application.routes.draw do
  resource :session, only: [:create, :destroy]
  get "admin", to: "sessions#new"
  resources :passwords, param: :token
  get "welcome/download"
  get "welcome/customer"
  get "welcome/permissions"

  get "app", to: "pages#app"

  scope module: :admin do
    resources :categories
    resources :products, except: :index do
      member do
        put "availability", to: "products#toggle_availability"
      end
    end

    resource :balance, only: :show do
      get ":cid/add-tokens", to: "balances#add_tokens", as: :add_tokens
      put ":cid/update", to: "balances#update", as: :update_customer
    end

    get "account", to: "pages#account"
  end

  resources :customers, only: [:create]
  post "push_subscriptions", to: "push_subscriptions#create"

  get "up" => "rails/health#show", :as => :rails_health_check

  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker

  root "pages#home"
end
