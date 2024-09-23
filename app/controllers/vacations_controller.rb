class VacationsController < ApplicationController
  before_action :set_vacation, only: %i[show update destroy]
  before_action :authorize_vacation, only: %i[create update destroy]

  def index
    @vacations = GetVacations.new(start_date: params[:start_date], end_date: params[:end_date]).call
    render json: @vacations, status: :ok
  end

  def show
    render json: @vacation, status: :ok
  end

  def create
    @vacation = Vacation.create!(vacation_params)
    render json: @vacation, status: :created
  end

  def update
    @vacation.update!(vacation_params)
    render json: @vacation, status: :ok
  end

  def destroy
    @vacation.destroy
    head :no_content
  end

  private

  def set_vacation
    debugger
    @vacation = Vacation.find(params[:id])
  end

  def vacation_params
    params.require(:vacation).permit(:start_date, :end_date, :user_id)
  end

  def authorize_vacation
    authorize Vacation
  end
end
