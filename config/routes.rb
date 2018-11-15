Rails.application.routes.draw do

  ## Customer routes
  devise_for :customers, :controllers => { :registrations => "customer/registrations" }
  devise_scope :customer do
    get 'customer/login', to: 'devise/sessions#new'
    get 'customer/signup', to: 'devise/registrations#new'
    get 'customer/password-settings', to: 'customer/registrations#edit'
    get 'customer/retrieve-password', to: 'devise/passwords#new'
  end
  authenticated :customer do
    root 'customers#dashboard', as: :authenticated_customer_root
  end
  get 'customers/make_reservation', to: 'customers#make_reservation'
  get '/customers/dashboard', to: 'customers#dashboard'
  post '/reserve', to: 'customers#reserve'
  get '/booking/confirmation', to: 'customers#booking_confirmation'
  get '/customer/inbox', to: 'conversations#inbox'
  ## END CUSTOMER ROUTES ##
  
  ## Chef routes
  devise_for :chefs, :controllers => { :registrations => "chef/registrations" }
  devise_scope :chef do
    get 'chef/login', to: 'devise/sessions#new'
    get 'chef/signup', to: 'devise/registrations#new'
    get 'chef/password-settings', to: 'chef/registrations#edit'
    get 'chef/retrieve-password', to: 'devise/passwords#new'
  end
  authenticated :chef do
    root 'chefs#dashboard', as: :authenticated_chef_root
  end
  get '/chef/dashboard', to: 'chefs#dashboard'
  get '/cook/inbox', to: 'conversations#inbox'
  ## END CHEF ROUTES ##
  
  ## RESOURCES
  resources :meals
  resources :conversations, except: [:delete, :edit, :update]
  resources :messages, only: :create
  
  ## Global routes
  get '/meal/search', to: 'main#search_page'
  get '/search', to: 'main#search'
  get '/new-meal', to: 'meals#new'
  get '/meal/:id/make-reservation', to: 'customers#make_reservation'
  get '/cook/:id', to: 'chefs#show'
  get '/chat/:id', to: 'conversations#show', as: 'chat'
  get '/new/chat', to: 'conversations#create'
  post '/create_message', to: 'conversations#create_message'
  get '/star/:id', to: 'conversations#star', as: "star_conversation"
  get '/archive/:id', to: 'conversations#archive', as: "archive_conversation"
  get '/unarchive/:id', to: 'conversations#unarchive', as: "unarchive_conversation"
  get '/inbox/archived', to: 'conversations#archived'
  get '/inbox/all', to: 'conversations#all'
  
  
  
  root 'main#home'
end
