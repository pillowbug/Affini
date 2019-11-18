Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :connections do
    resources :glances, only: [:create, :update, :destroy]
    end
  end
  resources :checkins do
    resources :attendees, only: [:create, :destroy]
  end
  # resources :tags, only: [:index, :show, :create, :update, :destroy]
  resources :users do
    resources :connection_tags, only [:create, :destroy]
  end
end
