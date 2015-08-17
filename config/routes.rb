Rails.application.routes.draw do

  resources :reservations, only: [:index, :create]
  root to: 'reservations#index'
end
