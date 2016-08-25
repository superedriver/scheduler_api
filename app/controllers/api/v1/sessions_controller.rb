module Api::V1
  class SessionsController < ApplicationController
    skip_before_action :authorize, only: [:create, :destroy]

    # POST api/v1/login
    def create
      user = User.find_by(email: params[:email])
      # If the user exists AND the password entered is correct.
      if user && user.authenticate(params[:password])
        user.update_attribute(:token, User.encrypt(User.new_token))
        render json: {
            "message": I18n.t("confirms.user.logged_in"),
            "token": user.token
        }
      else
      # If user's login doesn't work, send them back to the login form.
        render json: {
            "message": I18n.t("errors.user.wrong_credentials")
        }, status: 401
      end
    end

    # DELETE api/v1/logout
    def destroy
      if current_user
        current_user.update_attribute(:token, User.encrypt(User.new_token))
        render json: {
            "message": I18n.t("confirms.user.logged_out")
        }
      else
        render json: {
            "message": I18n.t("errors.user.logout")
        }, status: 403
      end
    end
  end
end
