class AccountActivationsController < ApplicationController
  # invite user
  def create
    user = InviteUser.new(invite_params: invite_params, current_user: current_user).call
    render json: { message: "User invited successfully" }, status: :ok if user
  end

  # activate user
  def update
    user = ActivateUser.new(user_id: params[:id], activate_params: activate_params).call
    token = JwtCreater.new(user: user, device_id: activate_params[:device_id]).call
    render json: { message: "User activated successfully", token: token }, status: :ok if token
  end

  private

  def invite_params
    params.require(:user).permit(%i[name email title phone_number admin])
  end

  def activate_params
    params.require(:user).permit(%i[password password_confirmation activation_token device_id])
  end
end
