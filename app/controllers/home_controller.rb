class HomeController < ApplicationController
  def index
  end

  def ui
    flash.now[:success] = "Flash message example"
  end
end
