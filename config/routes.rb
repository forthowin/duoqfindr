Rails.application.routes.draw do
  root 'static_pages#home'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
  post '/search', to: 'searches#show'

  resources :users, except: [:index, :destroy]
  resources :messages, only: [:create] do
    member do
      post :reply
    end
  end
  resources :conversations, only: [:index, :show]

end
