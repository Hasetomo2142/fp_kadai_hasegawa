Rails.application.routes.draw do
  devise_for :planners, controllers: {
    sessions:      'planners/sessions',
    passwords:     'planners/passwords',
    registrations: 'planners/registrations'
  }
  resources :planners, controller: 'planners/planners', only: %i[index show edit]
  get "search/planners" => "planners/planners#search", as: :planners_search
  get "home/planners" => "planners/planners#home", as: :planners_home

  devise_for :clients, controllers: {
    sessions:      'clients/sessions',
    passwords:     'clients/passwords',
    registrations: 'clients/registrations'
  }
  get "home/clients" => "clients/clients#home", as: :clients_home
  

  resources :meetings, controller: 'meetings/meetings', only: %i[index new create edit update destroy]
  get "search/meetings" => "meetings/meetings#search", as: :meetings_search
  post "meetings/:id/cancel" => "meetings/meetings#cancel", as: :meetings_cancel

  root "static_pages#home"
  get "static_pages/help"
  get "static_pages/about" => "static_pages#about", as: :about

end
