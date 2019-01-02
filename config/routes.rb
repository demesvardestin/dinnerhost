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
    root 'customers#index', as: :authenticated_customer_root
  end
  get 'customers/make_reservation', to: 'customers#make_reservation'
  get '/customers/dashboard', to: 'customers#dashboard'
  get '/inbox', to: 'conversations#inbox'
  get '/bookings', to: 'customers#bookings'
  get '/reservation/:id/meals', to: 'customers#reservation_meals'
  get '/edit/profile', to: 'customers#edit'
  get '/customer/edit/profile', to: 'customers#edit'
  get '/featured-listings', to: 'customers#featured_listings'
  get '/:location/listings', to: 'meals#location_based_listings'
  get '/edit/verification', to: 'customers#edit_verification'
  get '/submit_token', to: 'customers#submit_token'
  get '/save_listing/:id', to: 'customers#save_listing'
  get '/wishlist', to: 'customers#wishlist'
  get '/message_chef/:id', to: 'customers#message_chef'
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
    root 'chefs#payout_form', as: :authenticated_chef_root
  end
  get '/chef_onboarding', to: 'chefs#onboarding'
  get '/chef/dashboard', to: 'chefs#dashboard'
  get '/inbox', to: 'conversations#inbox'
  get '/chef/edit/profile', to: 'chefs#edit'
  get '/reservations', to: 'chefs#reservations'
  get '/accept_reservation', to: 'chefs#accept_reservation'
  get '/deny_reservation', to: 'chefs#deny_reservation'
  get '/reservation/:id/:customer_id/accepted', to: 'chefs#accepted'
  get '/reservations/pending', to: 'chefs#pending'
  get '/reservations/accepted', to: 'chefs#all_accepted'
  get '/reservations/denied', to: 'chefs#denied'
  get '/b/:shortened_url', to: 'reservations#book'
  get '/chef/edit/social', to: 'chefs#social_form'
  get '/chef/edit/payout', to: 'chefs#payout_form'
  get '/change_payout', to: 'chefs#change_payout'
  get '/my-requests', to: 'chefs#payout_form'
  get '/chef/edit/listings', to: 'chefs#my_listings'
  get '/verify_bank', to: 'chefs#verify_bank'
  get '/chef/account-created', to: 'chefs#account_created'
  get '/load_reservations', to: 'chefs#load_reservations_category'
  get '/sort_reservations', to: 'chefs#sort_reservations'
  get '/view_request/:id', to: 'chefs#view_request'
  get '/message_diner/:id', to: 'chefs#message_diner'
  post '/rate_diner', to: 'chefs#rate_diner'
  get '/add-ingredients/:id', to: 'meals#ingredients_list', as: 'add_ingredients'
  post "/create_ingredient", to: 'meals#create_ingredient'
  get '/listing/:id/ingredients', to: 'meals#ingredients_list'
  get '/remove_ingredient', to: 'meals#remove_ingredient'
  get '/trigger_payout', to: 'chefs#trigger_payout'
  ## END CHEF ROUTES ##
  
  ## RESOURCES
  resources :conversations, except: [:delete, :edit, :update]
  resources :messages, only: :create
  resources :chefs, :reservations, :customers, :meals
  ## END RESOURCES ##
  
  ## Global routes
  get '/meal/search', to: 'main#search_page'
  get '/search', to: 'main#search'
  get '/new-dish', to: 'meals#new'
  get '/meal/:id/booking-confirmation', to: 'meals#booking_confirmation'
  get '/cook/:id', to: 'chefs#show'
  get '/cook/:username', to: 'chefs#show'
  get '/chef/:username', to: 'chefs#show'
  get '/chat/:id', to: 'conversations#show', as: 'chat'
  get '/dish/:id/:slug', to: 'meals#show', as: 'dish'
  get '/dish/:id/:slug/edit', to: 'meals#edit', as: 'edit_dish'
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
  get '/booking-complete', to: 'reservations#booking_complete'
  get '/booking-accepted', to: 'reservations#booking_accepted'
  get '/booking/confirmation/:id', to: 'reservations#booking_confirmation'
  post '/submit_cancellation_request', to: 'reservations#cancel_reservation'
  post '/report-cook', to: 'main#report'
  post '/rate', to: 'main#rate'
  post '/rate_meal', to: 'main#rate_meal'
  get '/booking-estimate', to: 'reservations#booking_estimate'
  get '/search_meal_reviews', to: 'meals#search_meal_reviews'
  get '/browse_reviews', to: 'meals#browse_reviews'
  get '/tagged/:tag', to: 'meals#search_by_tag'
  get '/category/:category', to: 'meals#search_by_category'
  get '/filter_dishes', to: 'meals#filtered_search'
  get '/refer-a-chef', to: 'main#refer_a_chef'
  post '/submit-chef-referral', to: 'main#submit_chef_referral'
  get '/referral', to: 'main#referral'
  get '/verify_referral/:ref', to: 'main#verify_referral'
  get '/join', to: 'main#join'
  get '/new_user_guidelines', to: 'main#new_user_guidelines'
  get '/accept_guidelines', to: 'main#accept_guidelines'
  ## END GLOBAL ROUTES ##
  
  
  
  root 'main#home'
end
