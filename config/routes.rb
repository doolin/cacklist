Cacklist::Application.routes.draw do
  root to: 'pages#home'

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  get '/contact', to: 'pages#contact'
  get '/about', to: 'pages#about'
  get '/help', to: 'pages#help'
  get '/profile', to: 'pages#profile'

  get '/signup', to: 'users#new'
  get '/signin', to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'
end
