Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "/about", to: "static_pages#about"
    get "/register", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users
    resources :password_resets
    root "static_pages#home"
  end
end
