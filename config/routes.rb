Rails.application.routes.draw do
  constraints subdomain: "team.tamcafe" do
    scope module: :admin do
      resource :session, only: [:create, :destroy]
      put "toggle_open_cafe", to: "cafes#toggle_open_cafe"

      resources :orders, only: :index do
        member do
          patch "receive", to: "orders#receive"
          patch "prepare", to: "orders#prepare"
          patch "deliver", to: "orders#deliver"
          patch "cancel", to: "orders#cancel"
        end
      end

      resources :categories
      resources :products, except: [:index, :destroy] do
        member do
          put "availability", to: "products#toggle_availability"
        end
      end

      resource :balance, only: :show do
        get ":cid/add-tokens", to: "balances#add_tokens", as: :add_tokens
        put ":cid/update", to: "balances#update", as: :update_customer
      end

      get "settings", to: "pages#settings"
      get "login", to: "pages#login", as: :team_login

      get "/", to: "orders#index"
    end
  end

  constraints subdomain: "tamcafe" do
    get "welcome/download"
    get "welcome/customer"
    get "welcome/permissions"

    get "app", to: "pages#app"
    get "tokens", to: "pages#tokens"
    get "tokens-payment", to: "pages#tokens_payment"

    resources :transactions, only: :create

    resources :order_items, only: [:new, :create, :update, :destroy]
    resources :orders, only: [:index, :show, :update] do
      member do
        patch "finalize", to: "orders#finalize"
      end
    end

    resources :customers, only: [:create]
    post "push_subscriptions", to: "push_subscriptions#create"
    get "tv", to: "pages#tv"

    get "/", to: "pages#home"
  end

  get "manifest" => "pwa#manifest", :as => :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker

  get "up" => "rails/health#show", :as => :rails_health_check

  root "pages#mrshq"
end
