class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  # before_action :authorize_request, except: :create

  def index
    render json: User.all, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    result = RegisterUser.new(user_params: user_params, company_params: company_params).call
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
    params.require(:user).permit(%i[name email password password_confirmation title phone_number company_id])
  end

  def company_params
    params.require(:user).permit(company_attributes: %i[name timezone start_day])[:company_attributes]
  end
end