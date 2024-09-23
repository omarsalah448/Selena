class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  skip_before_action :authorize_request, only: %i[create]
  after_action :verify_authorized, except: %i[index create]
  after_action :verify_policy_scoped, only: :index

  def index
    @users = policy_scope(User)
    @users = FilterUsersVacations.new(users: @users, start_date: params[:start_date], end_date: params[:end_date]).call
    render json: @users, status: :ok
  end

  # def show
  #   authorize @user
  #   render json: @user, status: :ok
  # end

  def show
    authorize @user
    @vacations = GetUserVacation.new(user: @user, start_date: params[:start_date], end_date: params[:end_date]).call
    render json: { user: @user, vacations: @vacations }, status: :ok
  end

  def create
    user, token = RegisterUser.new(user_params: user_params, device_id: params[:device_id], company_params: company_params).call
    render json: { user: UserSerializer.new(user), token: token }, status: :created if user.persisted? && token.present?
  end

  def update
    authorize @user
    render json: @user, status: :ok if @user.update!(user_params)
  end

  def destroy
    authorize @user
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
