Rails.application.routes.draw do
  resource :session, only: [:create, :destroy]
  get "admin", to: "pages#admin"
  resources :passwords, param: :token
  get "welcome/download"
  get "welcome/customer"
  get "welcome/permissions"

  get "app", to: "pages#app"
  get "tokens", to: "pages#tokens"

  resources :order_items, only: [:new, :create, :update]
  resources :orders, only: [:show, :edit, :update] do
    member do
      patch "finalize", to: "orders#finalize"
    end
  end

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

  namespace :admin do
    resources :orders, only: :index do
      member do
        patch "receive", to: "orders#receive"
        patch "prepare", to: "orders#prepare"
        patch "deliver", to: "orders#deliver"
        patch "cancel", to: "orders#cancel"
      end
    end
  end

  resources :customers, only: [:create]
  post "push_subscriptions", to: "push_subscriptions#create"

  get "up" => "rails/health#show", :as => :rails_health_check

  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker

  root "pages#home"
end
