Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users
  resources :companies
  resources :vacations
  resources :account_activations, only: %i[create update]
  post "/login", to: "auth#login"
  delete "/logout", to: "auth#logout"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  resources :time_logs, only: [:index, :create, :update, :destroy]

  root to: "users#index"

  namespace :api do
    namespace :v1 do
      resources :companies
    end
  end

end
