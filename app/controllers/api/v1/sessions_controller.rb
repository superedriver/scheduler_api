module Api::V1
  class SessionsController < ApplicationController
    skip_before_action :authorize, only: [:create, :destroy]

    # POST /v1/login
    def create
      # when smb logged in
      if current_user
        render json: I18n.t("errors.user.login"), status: 403
      else
        user = User.find_by(email: params[:email])
        # If the user exists AND the password entered is correct.
        if user && user.authenticate(params[:password])
          # Save the user id inside the browser cookie. This is how we keep the user
          # logged in when they navigate around our website.
          session[:user_id] = user.id
          render json: I18n.t("confirms.user.logged_in")
        else
        # If user's login doesn't work, send them back to the login form.
          render json: I18n.t("errors.user.wrong_credentials"), status: 401
        end
      end
    end

    # GET /v1/logout
    def destroy
      if current_user
        session[:user_id] = nil
        render json: I18n.t("confirms.user.logged_out")
      else
        render json: I18n.t("errors.user.logout"), status: 403
      end
    end
  end
end
