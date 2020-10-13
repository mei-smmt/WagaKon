Rails.application.routes.draw do
  root to: "toppages#index"
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :create, :edit, :update]

  resources :articles, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :materials, :steps, only: [:new, :create] do
      collection do
        get :edit
        patch :update
      end
    end
  end
end
