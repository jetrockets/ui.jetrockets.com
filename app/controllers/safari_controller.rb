class SafariController < ApplicationController
  layout "safari"
  include Pagy::Backend

  def index
    @pagy, @tasks = pagy(Task.order(:is_completed), items: 20)
  end
end
