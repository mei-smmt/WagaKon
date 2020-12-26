Rails.application.routes.draw do
  root to: "toppages#index"
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :create, :edit, :update] do
    collection do
      get :search
    end
    member do
      get :password_edit
      patch :password_update
      get :favorite_recipes
      get :draft_recipes
      get :friends
    end
  end
  
  resources :relationships, only: [:create, :update, :destroy]
  resources :bookmarks, only: [:create, :destroy]
  resources :meals, only: [:index, :show]
  resources :menus, only: [:create, :destroy]

  resources :recipes, only: [:show, :new, :create, :edit, :update, :destroy] do
    collection do
      get :keyword_search
      get :feature_search
    end
    member do
      get :preview
      patch :publish
      patch :stop_publish 
    end
    resources :ingredients, :steps, only: [:new, :create] do
      collection do
        get :edit
        patch :update
      end
    end
  end
end
