Rails.application.routes.draw do
  root 'static_pages#home'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
  get '/search', to: 'searches#show'
  post '/search', to: 'searches#update'
  get '/about', to: 'static_pages#about'

  resources :users, except: [:index, :destroy]
  resources :messages, only: [:create] do
    member do
      post :reply
    end
  end
  resources :conversations, only: [:index, :show]

end
