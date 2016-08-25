module Api::V1
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]
    skip_before_action :authorize, only: [:create]

    # GET api/v1/users
    def show
      render json: @user
    end

    # POST api/v1/users (/registration)
    def create
      if current_user
        render json: I18n.t("errors.user.login"), status: 403
      else
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :created, location: api_v1_users_path
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end
    end

    # PATCH/PUT api/v1/users
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE api/v1/users/1
    def destroy
      @user.destroy
      render json: I18n.t("confirms.user.success_destroyed")
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = current_user

        unless @user
          render json: I18n.t("errors.user.not_found"), status: 404
        end
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :token)
      end
  end
end
