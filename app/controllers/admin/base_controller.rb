class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :require_admin!

  private

  def require_admin!
    redirect_to root_path unless current_account.admin?
  end
end
