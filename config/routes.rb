Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  get "/privacy", to: "home#privacy"
  get "/terms", to: "home#terms"
  root "home#index"
end
