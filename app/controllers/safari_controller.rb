class SafariController < ApplicationController
  layout "safari"

  def index
    @tasks = Task.all
  end
end
