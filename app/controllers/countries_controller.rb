class CountriesController < ApplicationController
  def index
    q = params[:q]
    countries = ISO3166::Country.all.select { |country|
      q.blank? || country.common_name.downcase.include?(q.downcase)
    }
    render json: countries.map { |c| { value: c.alpha2, label: c.common_name } }
  end
end
