Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  constraints Rodauth::Rails.authenticate do
    get "/accounts", to: "accounts#index"
  end

  get "/privacy", to: "home#privacy"
  get "/terms", to: "home#terms"

  root "home#index"

  if Rails.env.development?
    get "/ui", to: "home#ui"
  end
end
