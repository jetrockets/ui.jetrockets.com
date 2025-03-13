# This controller has been generated to enable Rails' resource routes.
# More information on https://docs.avohq.io/2.0/controllers.html
class Avo::AccountsController < Avo::ResourcesController
  include Pagy::Backend
  include Pagy::Frontend

  def index
    @pagy, @accounts = pagy(Account.all, items: 10)
  end
end
