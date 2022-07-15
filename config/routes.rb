Rails.application.routes.draw do

  # Home Controller
  root "home#Index"
  get "home/login", to: "home#login"
  post 'home/login', to: "home#authentication", as: :authentication
  get 'home/logout', to: "home#logout"
  get 'home/register', to: "home#register"
  get 'home/edit', to: "home#edit"
  post 'home/edit', to: 'home#save'
  get 'home/about_us', to: 'home#about'
  get 'home/privacy', to: 'home#privacy_policy'
  get 'home/password_recovery', to: "home#password_recovery"
  post 'home/password_recovery', to: "home#forgot_password", as: :forgot_password

  get 'home/update_password', to: "home#update_password"
  post 'home/update_password', to: "home#update", as: :update
  resources :home

  #Admin Controller

  get 'admin/index', to: "admin#index"
  get 'admin/project_details/:id', to: "admin#project_details"
  post 'admin/project_details/:id', to: "admin#project_details", as: :admin_project_details
  get 'admin/project_details', to: "admin#report_project"
  post 'admin/project_details', to: "admin#report_project", as: :admin_report_project


  get 'admin/profile/:id', to: "admin#profile", as: :admin_profile
  get 'admin/profile', to: "admin#report_user"
  post 'admin/profile', to: "admin#report_user", as: :admin_report_user

  get 'admin/report_request', to: "admin#report_request"
  get 'admin/report_request_details/:id', to: "admin#report_request_details"
  post 'admin/report_request_details/:id', to: "admin#report_request_details", as: :report_request_details
  post 'admin/report_request_details', to: "admin#complete_report_request", as: :complete_report_request

  resources :admin

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

  get 'user/profile/:id', to: "user#profile", as: :profile

  get 'user/my_account/topup', to: "user#topup"
  post 'user/my_account/topup', to: "user#top_up_process", as: :topup_process

  get 'user/customer_service_category', to: "user#customer_service_category"
  post 'user/customer_service_category', to: "user#customer_service", as: :service

  get 'user/customer_service', to: "user#customer_service"
  post 'user/customer_service', to: "user#customer_service_request", as: :request

  resources :user
  
end
