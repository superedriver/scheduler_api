class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session

  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authorize

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize
    render json: I18n.t("errors.user.non_authorized"), status: 401 unless current_user
  end
end
