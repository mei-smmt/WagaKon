Rails.application.routes.draw do
  root to: "toppages#index"
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :new, :create, :edit, :update]
  
  resources :articles, only: [:show, :new, :create, :edit, :update, :destroy]

  get "/:id/materials/new", to: "materials#new"
  resources :materials, only: [:create, :edit, :update, :destroy]
  
  get "/:id/steps/new", to: "steps#new"
  resources :steps, only: [:create, :edit, :update, :destroy]
end
