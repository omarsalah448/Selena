class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  # before_action :authorize_request, except: :create

  def index
    render json: User.all, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    result = UserRegistrationService.new(user_params, company_params).call
    render json: { user: result, company: result.company }, status: :created
  end

  def update
    render json: @user, status: :ok if @user.update!(user_params)
  end

  def destroy
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :title, :phone_number, :company_id)
  end

  def company_params
    params.require(:user).permit(company_attributes: [:name, :timezone, :work_week_start])[:company_attributes]
  end
end