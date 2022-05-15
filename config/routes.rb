Rails.application.routes.draw do
  get 'grid/index'
  post 'grid/upload'
  get 'grid/layout'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "grid#index"
end
