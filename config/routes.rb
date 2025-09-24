Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  constraints Rodauth::Rails.authenticate do
    get "/accounts", to: "accounts#index"
  end

  get "/privacy", to: "home#privacy"
  get "/terms", to: "home#terms"

  # UI Documentation routes
  namespace :ui do
    root "ui#index"
    get "getting_started"
    get "good_to_know"

    # Component pages
    get "accordion"
    get "alert"
    get "avatar"
    get "badge"
    get "button"
    get "button_group"
    get "card"
    get "clipboard"
    get "drawer"
    get "dropdown"
    get "flash_message"
    get "icon"
    get "modal"
    get "pagy"
    get "popover"
    get "table"
    get "tabs"
    get "tooltip"
    get "turbo_confirm"
    get "form_builder"
    get "typography"
  end

  root "ui#index"
end
