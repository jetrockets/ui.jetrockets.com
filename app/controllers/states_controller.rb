class StatesController < ApplicationController
  def index
    container = params[:container]
    target = params[:target]
    country = ISO3166::Country.new(params[:country_code] || params[:country])

    render locals: {
      container: container,
      target: target,
      country: country
    }
  end
end
