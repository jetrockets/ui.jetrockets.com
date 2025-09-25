class HomeController < ApplicationController
  def index
    redirect_to ui_path if Rails.env.development?
  end

  def privacy
  end

  def terms
  end
end
