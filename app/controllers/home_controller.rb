class HomeController < ApplicationController
  def index
    flash.now[:success] = "Flash message example"
  end

  def ui
  end
end
