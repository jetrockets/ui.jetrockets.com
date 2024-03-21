Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  constraints Rodauth::Rails.authenticate do
    if defined?(Avo::Engine)
      mount Avo::Engine, at: Avo.configuration.root_path
    end
  end

  get "/privacy", to: "home#privacy"
  get "/terms", to: "home#terms"

  get "/ui", to: "home#ui"
  root "home#index"
end
