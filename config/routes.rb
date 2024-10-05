Rails.application.routes.draw do
  get "welcome/download"
  get "welcome/customer"
  get "welcome/permissions"
  resources :products
  resources :categories
  resources :customers, only: [:create]
  post "push_subscriptions", to: "push_subscriptions#create"

  get "up" => "rails/health#show", :as => :rails_health_check

  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker

  root "pages#home"
end
