Rails.application.routes.draw do
  devise_for :planners, controllers: {
    sessions:      'planners/sessions',
    passwords:     'planners/passwords',
    registrations: 'planners/registrations'
  }
  resources :planners, controller: 'planners/planners', only: %i[index show]
  get "search/planners" => "planners/planners#search", as: :planners_search

  devise_for :clients, controllers: {
    sessions:      'clients/sessions',
    passwords:     'clients/passwords',
    registrations: 'clients/registrations'
  }
  get "clients/home" => "clients/clients#home", as: :clients_home

  resources :meetings, controller: 'meetings/meetings', only: %i[index new create edit update destroy]
  get "search/meetings" => "meetings/meetings#search", as: :meetings_search
  post "meetings/:id/cancel" => "meetings/meetings#cancel", as: :meetings_cancel

  root "static_pages#home"
  get "static_pages/help"
  get "static_pages/about" => "static_pages#about", as: :about

end
