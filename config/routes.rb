Rails.application.routes.draw do
  devise_for :stores, :controllers => {:registrations => "store/registrations"}
  devise_scope :store do
    get 'store/login', to: 'devise/sessions#new'
    get 'store/signup', to: 'devise/registrations#new'
    get 'store/password-settings', to: 'store/registrations#edit'
    get 'store/retrieve-password', to: 'devise/passwords#new'
  end
  
  ## Stores routes
  get '/dashboard', to: 'stores#dashboard'
  get '/edit/profile', to: 'stores#edit_profile'
  get '/edit/hours', to: 'stores#edit_hours'
  get '/register-a-store', to: 'layouts#register'
  get '/update_sessions_count', to: 'stores#update_sessions_count'
  get '/earnings', to: 'stores#earnings'
  get '/help', to: 'main#help'
  get '/add_data_to_firestore', to: 'stores#add_data_to_firestore'
  get '/inventory/new', to: 'stores#add_new_item'
  get '/inventory', to: 'stores#inventory'
  
  resources :stores
  
  root 'main#index'
end
