Rails.application.routes.draw do

  get '/:locale' => 'locations#index', as: :switch
  root 'locations#index'

  resources :users,               only: [ :show, :new, :create ]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  get "auth/github/callback" => 'sessions#create'

  get "auth/:provider" => 'sessions#create', as: 'provider_login'
  # get    "/login",  to: 'sessions#new'
  post   "/login",  to: 'sessions#create', as: 'login'
  delete "/logout", to: 'sessions#destroy'

end
