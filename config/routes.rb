HawaiianAir::Application.routes.draw do
  root :to => 'fares#index'


  devise_for :users

  resources :users
  resources :fares do
    get :details
  end

  # resources :pages, controller: 'pages', only: [:show]
end
