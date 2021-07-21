Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "/about", to: "static_pages#about"
    get "/register", to: "users#new"
  
    resources :users
  
    root "static_pages#home"
  end
end
