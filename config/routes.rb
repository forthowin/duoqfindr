Rails.application.routes.draw do
  root 'static_pages#home'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
  get '/search', to: 'searches#show'
  get '/about', to: 'static_pages#about'
  post '/token', to: 'users#token'
  post '/link-account', to: 'users#link_account'
  post '/unlink-account', to: 'users#unlink_account'
  get '/forgot-password-confirmation', to: 'forgot_passwords#confirm'
  get '/invalid-token', to: 'static_pages#invalid_token'

  resources :users, except: [:index, :destroy]
  resources :messages, only: [:create] do
    member do
      post :reply
    end
  end
  resources :conversations, only: [:index, :show]
  resources :forgot_passwords, only: [:new, :create]
  resources :reset_passwords, only: [:show, :create]
end
