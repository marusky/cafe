Rails.application.routes.draw do
  constraints subdomain: "team.kafeem" do
    scope module: :admin do
      resource :session, only: [:create, :destroy]

      resources :categories
      resources :products, except: :index do
        member do
          put "availability", to: "products#toggle_availability"
        end
      end

      resources :orders, only: :index do
        member do
          patch "receive", to: "orders#receive"
          patch "prepare", to: "orders#prepare"
          patch "deliver", to: "orders#deliver"
          patch "cancel", to: "orders#cancel"
        end
      end

      resource :balance, only: :show do
        get ":cid/add-tokens", to: "balances#add_tokens", as: :add_tokens
        put ":cid/update", to: "balances#update", as: :update_customer
      end

      get "account", to: "pages#account"
      get "login", to: "pages#login", as: :team_login

      get "/", to: "orders#index"
    end
  end

  constraints subdomain: "kafeem" do
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

    resources :customers, only: [:create]
    post "push_subscriptions", to: "push_subscriptions#create"

    get "up" => "rails/health#show", :as => :rails_health_check

    get "manifest" => "pwa#manifest", :as => :pwa_manifest
    get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker

    get "/", to: "pages#home"
  end

  root "pages#mrshq"
end
