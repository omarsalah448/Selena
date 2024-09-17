class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy]
  # before_action :authorize_request

  def index
    render json: Company.all, status: :ok
  end

  def show
    render json: @company, status: :ok
  end

  def create
    render json: Company.create!(company_params), status: :created
  end

  def update
    render json: @company, status: :ok if @company.update!(company_params)
  end

  def destroy
    @company.destroy
    head :no_content
  end

  private
  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :timezone, :work_week_start)
  end
end