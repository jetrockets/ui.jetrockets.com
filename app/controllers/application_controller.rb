class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :turbo_frame_request?
end
