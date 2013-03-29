HawaiianAir::Application.routes.draw do
  authenticated :user do
    root :to => 'fares#index'
  end

  root :to => "home#index"

  devise_for :users

  resources :users
  resources :fares do
    get :details
  end

  resources :pages, controller: 'pages', only: [:show]
end
