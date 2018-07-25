Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'websites#landing_page'
  resources :websites
  put 'users/change_password/:id' => 'users#change_password'
  resources :subscribers
  resources :users
end
