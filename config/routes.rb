Rails.application.routes.draw do
  root 'static_pages#home'

  get '/login', to: 'sessions#new'
  get '/register', to: 'users#new'
  resources :users, except: [:index, :destroy]

end
