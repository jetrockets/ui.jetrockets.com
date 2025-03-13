class AccountsController < ApplicationController
  def index
    @pagy, @accounts = pagy(Account.all, items: 10)
  end
end