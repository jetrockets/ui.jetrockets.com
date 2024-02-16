class HomeController < ApplicationController
  def index
    flash.now[:success] = "Flash message example"
  end
end
