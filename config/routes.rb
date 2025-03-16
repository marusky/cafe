Rails.application.routes.draw do
  get "welcome/download"
  get "welcome/customer"
  get "welcome/permissions"

  get "app", to: "pages#app"

  resources :products, except: :index do
    member do 
      put "availability", to: "products#toggle_availability"
    end
  end
  resources :categories
  resources :customers, only: [:create]
  post "push_subscriptions", to: "push_subscriptions#create"

  resource :balance, only: :show do
    get ":cid/add-tokens", to: "balances#add_tokens", as: :add_tokens
    put ":cid/update", to: "balances#update", as: :update_customer
  end

  get "up" => "rails/health#show", :as => :rails_health_check

  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker

  root "pages#home"
end
