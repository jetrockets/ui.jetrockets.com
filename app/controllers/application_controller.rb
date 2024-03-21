class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :current_account

  helper_method :current_account, :turbo_frame_request?

  private

  def current_account
    Current.account ||= rodauth.rails_account
  end
end
