class UserRegistrationService
  def initialize(user_params, company_params)
    @user_params = user_params
    @company_params = company_params
  end

  def call
    ActiveRecord::Base.transaction do
      create_company if @company_params.present?
      create_user
    end
  end

  private

  def create_company
    @company = Company.create!(@company_params)
    @user_params[:company_id] = @company.id
  end

  def create_user
    @user = User.new(@user_params)
    @user.role = :admin if @company.present?
    @user.save!
    @user
  end
end