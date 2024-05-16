Rails.application.routes.draw do
  get 'users/index'
  get '/current_user', to: 'current_user#index'
  get '/current_user/available_credits', to: 'current_user#available_credits'

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :admin do
    resources :bookings, only: [:index, :show, :update] do
      member do
        post 'cancel'
      end
    end
  end


  resources :rooms

  resources :fixed_bookings do
    member do
      post 'cancel'
    end
  end

  resources :bookings do
    collection do
      get 'day_available_slots'
      get 'upcoming'
    end
    member do
      post 'cancel'
    end
  end

  resources :users do
    get 'roles', on: :collection
  end

  resources :clinics do
    resources :rooms, only: [:index] #salas de uma clínica específica
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
