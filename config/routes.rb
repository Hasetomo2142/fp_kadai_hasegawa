Rails.application.routes.draw do
  devise_for :planners, controllers: {
    sessions:      'planners/sessions',
    passwords:     'planners/passwords',
    registrations: 'planners/registrations'
  }
  resources :planners, controller: 'planners/planners', only: %i[index show]
  get "planners/search" => "planners/search#search", as: :planners_search

  devise_for :clients, controllers: {
    sessions:      'clients/sessions',
    passwords:     'clients/passwords',
    registrations: 'clients/registrations'
  }
  get "clients/home" => "clients/home#home", as: :clients_home

  resources :meetings, controller: 'meetings/meetings', only: %i[new create edit update destroy]
  get "meetings/search" => "meetings/meetings#search", as: :meetings_search

  root "static_pages#home"
  get "static_pages/help"
  get "static_pages/about"

  resources :meetings
end
