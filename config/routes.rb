Rails.application.routes.draw do
  root 'static_pages#home'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
  get '/search', to: 'searches#edit'
  post '/search', to: 'searches#show'

  resources :users, except: [:index, :destroy]

end
