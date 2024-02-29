require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users
  
  resources :rooms
  resources :clinics
  resources :bookings do
    get 'weekly_slots', on: :collection
  end

  post 'auth/login', to: 'auth#login'
end
