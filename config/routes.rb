Rails.application.routes.draw do
  devise_for :stores
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'layouts#index'
end
