class HomeController < ApplicationController
  def index
  end

  def ui
    flash.now[:notice] = "This is a notice message asd asdasd aidksf gasdf gasukjfdgajskfg ashjkfg jkhs."
    flash.now[:alert] = "This is a notice message."
  end
end
