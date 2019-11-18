Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :connections do
    resources :glances
    end
  end
  resources :checkins
  resources :attendees, only: [:index, :show]
  resources :tags, only: [:index, :show, :create, :update, :destroy]
  resources :users do
    resources :connection_tags
  end
end
