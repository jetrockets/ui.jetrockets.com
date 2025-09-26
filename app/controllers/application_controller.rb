class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :current_account

  helper_method :current_account, :current_user, :turbo_frame_request?, :pagy

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: ->(exception) { render_error(500, exception) }
    rescue_from ActionController::UnknownFormat, with: ->(exception) { render_error(404, exception) }
    rescue_from ActionController::RoutingError, with: ->(exception) { render_error(404, exception) }
    rescue_from ActiveRecord::RecordNotFound, with: ->(exception) { render_error(404, exception) }
    rescue_from ActionPolicy::Unauthorized, with: ->(exception) { render_error(401, exception) }
  end

  private

  def current_account
    Current.account ||= rodauth.rails_account
  end

  def current_user
    Current.user ||= current_account&.user
  end

  def render_error(status, exception = nil)
    if exception.present?
      # Add error tracking here, e.g. Sentry, AppSignal, etc.
      # Appsignal.set_error(exception) if status == 500

      Rails.logger.error("Error #{exception.message}")
      Rails.logger.error("Backtrace #{exception.backtrace}")
    end

    respond_to do |format|
      format.html { render template: "errors/#{status}", layout: "application", status: status }
      format.any { head :ok, status: status }
    end
  end
end
