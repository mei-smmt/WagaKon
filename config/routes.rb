Rails.application.routes.draw do
  root to: "toppages#index"
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resource :users, only: [:create, :edit, :update, :destroy] do
    member do
      get :password_edit
      patch :password_update
      get :search
      get :favorite_recipes
      get :friends
    end
  end
  resources :users, only: [:show]

  resource :relationships, only: [:create, :update, :destroy]
  resource :bookmarks, only: [:create, :destroy]
  resource :meals, only: [:index, :show]
  resource :menus, only: [:create, :destroy]
  
  resource :recipes, only: [:new, :create]
  resources :recipes, only: [:show,  :edit, :update, :destroy] do
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
    resource :ingredients, :steps, only: [:edit, :update]
  end
end
