class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [ :login ]
  def login
    user, token = AuthenticateUser.new(email: login_params[:email], password: login_params[:password], device_id: login_params[:device_id]).call
    render json: { user: user, token: token }, status: :ok
  end

  def logout
    DestroyDeviceToken.new(user: @current_user, headers: request.headers).call
    render json: { message: "Logged out successfully" }, status: :ok
  end
  private
  def login_params
    params.require(:user).permit(:email, :password, :device_id)
  end
end