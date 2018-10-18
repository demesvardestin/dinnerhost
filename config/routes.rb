Rails.application.routes.draw do
  
  devise_for :shoppers
  ## Devise routes (stores)
  devise_for :stores, :controllers => {:registrations => "store/registrations"}
  devise_scope :store do
    get 'store/login', to: 'devise/sessions#new'
    get 'store/signup', to: 'devise/registrations#new'
    get 'store/password-settings', to: 'store/registrations#edit'
    get 'store/retrieve-password', to: 'devise/passwords#new'
  end
  authenticated :store do
    root 'stores#dashboard', as: :authenticated_store_root
  end
  
  ## Shopper routes
  get '/firebase_authentication', to: 'shoppers#firebase_authentication'
  get '/shoppers/:shopper_id/:shopper_uid/account/settings', to: 'shoppers#account_settings'
  get '/read_shopper_data_from_firestore', to: 'shoppers#read_data_from_firestore'
  get '/add_shopper_data_to_firestore', to: 'shoppers#add_data_to_firestore'
  get '/shoppers/:shopper_id/:shopper_uid/order-history', to: 'shoppers#order_history'
  post '/process_offline_order', to: 'carts#process_offline_order'
  get '/reorder', to: 'carts#reorder'
  get '/shoppers/:shopper_id/:shopper_uid/favorites', to: 'shoppers#favorites'
  get '/stores/:id/:slug', to: 'stores#show'
  post '/special_orders', to: 'shoppers#create_special_order'
  get '/clear_cart', to: 'carts#clear_cart'
  
  ## Global routes
  get '/uninitialize_firebase', to: 'main#uninitialize_firebase'
  get '/initialize_firebase', to: 'main#initialize_firebase'
  get '/register-a-store', to: 'main#register_a_store'
  get '/help', to: 'main#help'
  get '/search', to: 'main#search'
  get '/search_store', to: 'main#search_store'
  get '/initialize_cart', to: 'main#initialize_cart'
  post '/add_item_to_cart', to: 'carts#add_item'
  post '/remove_item_from_cart', to: 'carts#remove_item'
  get '/:id/checkout', to: 'carts#show'
  post '/submit_order', to: 'carts#submit_order'
  get '/carts/:id/:confirmation/:token', to: 'carts#confirmation'
  get '/change_delivery_type', to: 'carts#change_delivery_type'
  get '/register-a-store', to: 'main#register_a_store'
  post '/registration_requests', to: 'main#register'
  get '/send_email', to: 'main#send_email'
  post '/subscribe', to: 'main#subscribe'
  get '/contact-us', to: 'main#contact'
  get '/legal/terms', to: 'main#terms'
  get '/legal/privacy', to: 'main#privacy'
  get '/log_favorite', to: 'main#log_favorite'
  get '/firebase_listener', to: 'main#firebase_listener'
  post '/log_firebase_reviews_data', to: 'main#log_firebase_reviews_data'
  
  ## Stores routes
  get '/dashboard', to: 'stores#dashboard'
  get '/edit/profile', to: 'stores#edit_profile'
  get '/edit/hours', to: 'stores#edit_hours'
  get '/update_sessions_count', to: 'stores#update_sessions_count'
  get '/earnings', to: 'stores#earnings'
  get '/add_data_to_firestore', to: 'stores#add_data_to_firestore'
  get '/read_data_from_firestore', to: 'stores#read_data_from_firestore'
  get '/remove_data_from_firestore', to: 'stores#remove_data_from_firestore'
  get '/inventory/new', to: 'stores#add_new_item'
  get '/inventory', to: 'stores#inventory'
  get '/order-history', to: 'stores#order_history'
  get '/add_order_to_postgres', to: 'stores#add_data_to_postgres'
  post '/store_banner_image', to: 'stores#store_banner_image'
  get '/edit/banner', to: 'stores#edit_banner'
  get '/update_order', to: 'stores#update_order'
  get '/update_store', to: 'stores#update_store'
  get '/verify_store', to: 'stores#verify_store'
  get '/interval_analytics', to: 'stores#interval_analytics'
  get '/retrieve_earnings', to: 'stores#retrieve_earnings'
  get '/go_live', to: 'stores#go_live'
  get '/reload_stats', to: 'stores#reload_stats'
  get '/item-requests', to: 'stores#item_requests'
  get '/deny_request', to: 'stores#deny_request'
  get '/add_to_queue', to: 'stores#add_to_queue'
  patch '/special_order', to: 'stores#special_order'
  get '/alert_customer', to: 'stores#alert_customer'
  get '/mark_fulfilled', to: 'stores#mark_fulfilled'
  get '/update_unprocessed_orders_count', to: 'stores#update_unprocessed_orders_count'
  get '/update_item_requests_count', to: 'stores#update_item_requests_count'
  
  ## Callbacks
  post '/account', to: 'main#account'
  
  resources :stores
  
  root 'main#index'
end
