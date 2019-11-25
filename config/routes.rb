Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  authenticated { root to: 'users#show' }
  root to: 'pages#home'
  resources :connections, only: [:index, :show, :update, :destroy, :edit] do
    resources :glances, only: [:create, :update, :destroy], shallow: true
    resources :connection_tags, only: [:create, :destroy], shallow: true
    post 'send_connection_email', to: "connection_mail#send_connection_email"
  end
  resources :checkins do
    resources :attendees, only: [:create, :destroy], shallow: true
  end
  # resources :tags, only: [:index, :show, :create, :update, :destroy]
  resources :users, except: [:show, :index ] do
    resources :connections, only: [:new, :create]
  end
end
