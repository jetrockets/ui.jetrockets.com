class ApplicationController < ActionController::Base
  include Pagy::Backend
  default_form_builder FormBuilders::GroupedFormBuilder

  before_action :current_account

  helper_method :current_account, :turbo_frame_request?, :pagy

  private

  def current_account
    Current.account ||= rodauth.rails_account
  end
end
