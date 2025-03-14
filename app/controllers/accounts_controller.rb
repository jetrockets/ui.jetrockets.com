class AccountsController < ApplicationController
  def index
    @pagy, @accounts = pagy(Account.all, items: 10)

    render locals: {
      pagy: @pagy,
      accounts: @accounts
    }
  end
end
