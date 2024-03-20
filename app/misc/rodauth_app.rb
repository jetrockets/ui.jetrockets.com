class RodauthApp < Rodauth::Rails::App
  # primary configuration
  configure RodauthMain

  # secondary configuration
  # configure RodauthAdmin, :admin

  route do |r|
    rodauth.load_memory # autologin remembered users

    if rodauth.logged_in? &&
      (
        r.path.start_with?(rodauth.login_path) ||
        r.path.start_with?(rodauth.create_account_path) ||
        r.path.start_with?(rodauth.reset_password_request_path)
      )

      flash[:alert] = "You are already logged in"

      r.redirect rails_routes.root_url
    end

    r.rodauth # route rodauth requests

    # ==> Authenticating requests
    # Call `rodauth.require_account` for requests that you want to
    # require authentication for. For example:
    #
    # # authenticate /dashboard/* and /account/* requests
    # if r.path.start_with?("/dashboard") || r.path.start_with?("/account")
    #   rodauth.require_account
    # end

    # ==> Secondary configurations
    # r.rodauth(:admin) # route admin rodauth requests
  end
end
