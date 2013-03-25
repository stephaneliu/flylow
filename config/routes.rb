HawaiianAir::Application.routes.draw do
  authenticated :user do
    root :to => 'fares#index'
  end

  root :to => "pages#home"

  devise_for :users

  resources :users
  resources :fares

  resources :pages, controller: 'pages', only: [:show]
end
