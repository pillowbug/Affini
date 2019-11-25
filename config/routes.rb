Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  authenticated { root to: 'users#dashboard' }
  root to: 'pages#home'
  resources :connections, only: [:index, :show, :update, :destroy, :edit] do
    collection do
      get :onboard
    end
    member do
      get :onboard_edit
    end
    resources :glances, only: [:create, :update, :destroy], shallow: true
    resources :connection_tags, only: [:create, :destroy], shallow: true
  end
  resources :checkins do
    resources :attendees, only: [:create, :destroy], shallow: true
  end
  # resources :tags, only: [:index, :show, :create, :update, :destroy]
  resources :users, except: [ :index ] do
    resources :connections, only: [:new, :create]
  end
end
