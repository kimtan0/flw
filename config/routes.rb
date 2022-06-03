Rails.application.routes.draw do

  # Home Controller
  root "home#Index"
  get "login", to: "home#login"
  post 'login', to: "home#authentication", as: :authentication
  get 'register', to: "home#register"
  resources :home, only: [:create]

  # User Controller
  get 'user/Index', to: "user#Index"
  get 'user/project', to: "user#project"
  resources :user, only: [:create]
end
