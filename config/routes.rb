Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  constraints Rodauth::Rails.authenticate do
    get "/accounts", to: "accounts#index"

    namespace :user do
      resource :profile, only: [ :show, :update ], controller: "profile"
      resource :avatar, only: [ :create, :destroy ], controller: "avatar"
    end
  end

  get "/privacy", to: "home#privacy"
  get "/terms", to: "home#terms"

  if Rails.env.development?
    get "ui", to: "ui#index"
    # UI Documentation routes
    namespace :ui do
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
      get "typography"

      namespace :form_builders do
        get "core"
        get "default"
        get "text_field"
        get "text_area"
        get "select"
        get "choices"
        get "checkbox"
        get "radio_button"
        get "toggler"
        get "easepick"
      end
    end
  end

  root "home#index"
end
