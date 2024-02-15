class HomeController < ApplicationController
  def index
    flash[:success] = "Flash message example"
  end
end
