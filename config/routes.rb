Rails.application.routes.draw do
  root to: "toppages#index"
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :new, :create, :edit, :update]
  
  resources :articles
  resources :materials, only: [:new, :create, :edit, :update, :destroy]
  resources :steps, only: [:new, :create, :edit, :update, :destroy]
end
