Rails.application.routes.draw do
  devise_for :users
  get 'grid/index'
  post 'grid/upload'
  get 'grid/layout'
  post 'grid/compute'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "grid#index"
end
