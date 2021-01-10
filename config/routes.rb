Rails.application.routes.draw do
  root to: "toppages#index"
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resource :users, only: [:edit, :update]
  resources :users, only: [:show, :create, :destroy] do
    member do
      get :search
      get :password_edit
      patch :password_update
      get :favorite_recipes
      get :friends
    end
  end
  
  resources :relationships, only: [:create, :update, :destroy]
  resources :bookmarks, only: [:create, :destroy]
  resources :meals, only: [:index, :show]
  resources :menus, only: [:create, :destroy]

  resources :recipes, only: [:show, :new, :create, :edit, :update, :destroy] do
    collection do
      post :easy_create
      get :sort
      get :keyword_search
      get :feature_search
    end
    member do
      patch :easy_update
      patch :size_update
      patch :publish
      patch :stop_publish
    end
    resource :ingredients, :steps, only: [:edit, :update] do
    end
  end
end
