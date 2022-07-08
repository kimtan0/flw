Rails.application.routes.draw do

  # Home Controller
  root "home#Index"
  get "home/login", to: "home#login"
  post 'home/login', to: "home#authentication", as: :authentication
  get 'home/logout', to: "home#logout"
  get 'home/register', to: "home#register"

  get 'home/edit', to: "home#edit"
  post 'home/edit', to: 'home#save'

  resources :home

  # User Controller
  get 'user/Index', to: "user#Index"
  get 'user/project', to: "user#project"

  get 'user/project_category', to: "user#project_category"
  post 'user/project_category', to: "user#project", as: :userproject
  
  get 'user/project_details/:id', to: "user#project_details"
  post 'user/project_details/:id', to: "user#project_details", as: :project_details

  post 'user/project_details', to: "user#rate_freelancer", as: :rate_freelancer





  get  'user/project_details', to: "user#accept_project"
  post 'user/project_details', to: "user#accept_project", as: :accept_project
  post 'user/bid', to: "user#bid", as: :bid

  get 'user/project_edit', to: 'user#project_edit'
  post 'user/project_edit', to: "user#project_edit", as: :project_edit
  
  post 'user/:id/edit', to: 'user#edit'
  get 'user/my_project', to: "user#my_project"
  get 'user/my_account', to: "user#my_account"
  get 'user/my_account/my_accepted_project', to: "user#my_accepted_project"

  get 'user/my_account/my_accepted_project/accepted_project_details/:id', to: "user#accepted_project_details"
  post 'user/my_account/my_accepted_project/accepted_project_details/:id', to: "user#accepted_project_details", as: :accepted_project_details
  post 'user/my_account/my_accepted_project/accepted_project_details', to: "user#update_accepted_project_details", as: :update_accepted_project_details
  
  post 'user/my_account/my_accepted_project/accepted_project_details', to: "user#cancel_accepted_project", as: :cancel_accepted_project

  post get 'user/my_account/my_accepted_project/cancel_accepted_project_confirmation/:id', to: "user#cancel_accepted_project_confirmation", as: :cancel_confirmation
  post 'user/my_account/my_accepted_project/cancel_accepted_project_confirmation/:id', to: "user#cancel_accepted_project", as: :cancel


  post get 'user/my_account/my_accepted_project/complete_project_confirmation/:id', to: "user#complete_project_confirmation", as: :complete_confirmation
  post 'user/my_account/my_accepted_project/complete_project_confirmation/:id', to: "user#complete_project", as: :complete

  post get 'user/profile/:id', to: "user#profile", as: :profile


  get 'user/my_account/topup', to: "user#topup"
  post 'user/my_account/topup', to: "user#top_up_process", as: :topup_process

  resources :user
end
