class AccountsController < ApplicationController
  def index
    @pagy, @accounts = pagy(Account.all, limit: 20)

    render locals: {
      pagy: @pagy,
      accounts: @accounts
    }
  end
end