module Api::V1
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]
    skip_before_action :authenticate, only: [:create]
    # GET /v1/users
    def index
      @users = User.all

      render json: @users
    end

    # GET /v1/users/1
    def show
      render json: @user
    end

    # POST /v1/users
    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created, location: v1_user_path(@user)
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /v1/users/1
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/users/1
    def destroy
      @user.destroy
      render json: I18n.t("confirms.user.success_destroyed")
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find_by(id: params[:id])

        unless @user
          render json: I18n.t("errors.user.not_found"), status: 404
        end
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:name, :email)
      end
  end
end
