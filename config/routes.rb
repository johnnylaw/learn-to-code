Rails.application.routes.draw do
  root to: 'visitors#index'

  resources :quotes
  resources :posts
end
