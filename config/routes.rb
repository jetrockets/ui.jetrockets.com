Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  constraints Rodauth::Rails.authenticate do
    get "/accounts", to: "accounts#index"
  end

  get "/privacy", to: "home#privacy"
  get "/terms", to: "home#terms"

  get "/ui", to: "home#ui"
  root "home#index"

  get "/safari", to: "safari#index"
  get "/safari/new", to: "tasks#new", as: :new_safari_task
  get "/safari/edit/:id", to: "tasks#edit", as: :edit_safari_task
  resources :tasks, only: [ :create, :destroy, :update ]

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end
end
