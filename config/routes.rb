Rails.application.routes.draw do

  ## Customer routes
  devise_for :customers, :controllers => { :registrations => "customers/registrations", :sessions => "customers/sessions" }
  devise_scope :customer do
    get 'customer/login', to: 'devise/sessions#new'
    get 'customer/signup', to: 'devise/registrations#new'
    get 'customer/password-settings', to: 'customers/registrations#edit'
    get 'customer/retrieve-password', to: 'devise/passwords#new'
  end
  authenticated :customer do
    root 'customers#dashboard', as: :authenticated_customer_root
  end
  get 'customers/make_reservation', to: 'customers#make_reservation'
  get '/customers/dashboard', to: 'customers#dashboard'
  get '/inbox', to: 'conversations#inbox'
  get '/bookings', to: 'customers#bookings'
  get '/reservation/:id/meals', to: 'customers#reservation_meals'
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
  get '/inbox', to: 'conversations#inbox'
  get '/chef/edit/profile', to: 'chefs#edit'
  get '/reservations', to: 'chefs#reservations'
  get '/accept_reservation', to: 'chefs#accept_reservation'
  get '/deny_reservation', to: 'chefs#deny_reservation'
  get '/reservation/:id/accepted', to: 'chefs#accepted'
  get '/reservations/pending', to: 'chefs#pending'
  get '/reservations/accepted', to: 'chefs#all_accepted'
  get '/reservations/denied', to: 'chefs#denied'
  ## END CHEF ROUTES ##
  
  ## RESOURCES
  resources :conversations, except: [:delete, :edit, :update]
  resources :messages, only: :create
  resources :chefs
  resources :meals
  resources :reservations
  ## END RESOURCES ##
  
  ## Global routes
  get '/meal/search', to: 'main#search_page'
  get '/search', to: 'main#search'
  get '/new-dish', to: 'meals#new'
  get '/meal/:id/booking-confirmation', to: 'meals#booking_confirmation'
  get '/cook/:id', to: 'chefs#show'
  get '/chat/:id', to: 'conversations#show', as: 'chat'
  get '/new/chat', to: 'conversations#create'
  get '/new/customer/chat', to: 'conversations#contact_customer'
  post '/create_message', to: 'conversations#create_message'
  get '/star/:id', to: 'conversations#star', as: "star_conversation"
  get '/archive/:id', to: 'conversations#archive', as: "archive_conversation"
  get '/unarchive/:id', to: 'conversations#unarchive', as: "unarchive_conversation"
  get '/inbox/archived', to: 'conversations#archived'
  get '/inbox/all', to: 'conversations#all'
  get 'user_type', to: 'main#user_type'
  get '/c/:username', to: 'chefs#show'
  get '/book/:username', to: 'reservations#book', as: 'book'
  post '/reserve', to: 'reservations#reserve'
  post '/complete-reservation', to: 'reservations#complete_reservation'
  get '/booking_complete/:id', to: 'reservations#booking_complete'
  get '/booking/confirmation/:id', to: 'reservations#booking_confirmation'
  post '/report-cook', to: 'main#report'
  post '/rate', to: 'main#rate'
  get '/booking-estimate', to: 'reservations#booking_estimate'
  ## END GLOBAL ROUTES ##
  
  
  
  root 'main#home'
end
