Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'websites#landing_page'
  resources :websites
  get 'compare' => 'websites#web_compare'
end
