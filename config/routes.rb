Rails.application.routes.draw do
  root to: "toppages#index"
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :create, :edit, :update] do
    member do
      get :favorite_articles
    end
  end
  
  resources :bookmarks, only: [:create, :destroy]

  resources :articles, only: [:show, :new, :create, :edit, :update, :destroy] do
    collection do
      get :search
    end
    member do
      get :preview
    end
    resources :materials, :steps, only: [:new, :create] do
      collection do
        get :edit
        patch :update
      end
    end
  end
end
