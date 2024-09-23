class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show update destroy]

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
  end

  private
  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(%i[name timezone start_day])
  end
end