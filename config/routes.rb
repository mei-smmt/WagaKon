Rails.application.routes.draw do
  root to: "toppages#index"
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :new, :create, :edit, :update]
  
  resources :articles, only: [:show, :new, :create, :edit, :update, :destroy]

  get "/:id/materials/new", to: "materials#new"
  get "/:id/materials/edit", to: "materials#edit"
  resources :materials, only: [:create, :update]
  
  get "/:id/steps/new", to: "steps#new"
  get "/:id/steps/edit", to: "stepls#edit"
  resources :steps, only: [:create, :update]
end
