class HomeController < ApplicationController
  def index
    redirect_to ui_root_path
  end
end
