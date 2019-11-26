Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  authenticated { root to: 'users#dashboard' }
  root to: 'pages#home'
  resources :connections, only: [:index, :show, :create, :update, :destroy] do
    collection do
      get :onboard
    end
    member do
      patch :onboard, to: 'connections#onboard_update'
    end
    resources :glances, only: [:create, :update, :destroy], shallow: true
    resources :connection_tags, only: [:create, :destroy], shallow: true
    post 'send_connection_email', to: "connection_mail#send_connection_email"
  end
  resources :checkins do
    resources :attendees, only: [:create, :destroy], shallow: true
  end
  # resources :tags, only: [:index, :show, :create, :update, :destroy]
  resources :users, except: [ :index ]
end
