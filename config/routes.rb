HawaiianAir::Application.routes.draw do
  authenticated :user do
    root :to => 'fares#index'
  end

  root :to => "fares#index"

  devise_for :users

  resources :users
  resources :fares
end
