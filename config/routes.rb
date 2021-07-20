Rails.application.routes.draw do
  get "/about", to: "static_pages#about"
  get "/register", to: "users#new"

  resources :users

  root "static_pages#home"
end
