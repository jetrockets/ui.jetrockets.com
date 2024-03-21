class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :current_account, :turbo_frame_request?

  private

  def current_account
    rodauth.rails_account
  end
end
