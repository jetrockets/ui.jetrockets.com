class SafariController < ApplicationController
  layout "safari"

  def index
    @tasks = Task.order(:is_completed)
  end
end
