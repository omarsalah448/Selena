class RegisterUser
  def initialize(**params)
    @user_params = params[:user_params]
    @device_id = params[:device_id]
    @company_params = params[:company_params]
  end

  def call
    User.transaction do
      create_company if @company_params.present?
      create_user
      @user.device_tokens.find_or_create_by!(device_id: @device_id)
      @token = JwtCreater.new(user: @user, device_id: @device_id).call
    end
    [ @user, @token ]
  end

  private

  def create_company
    @company = Company.create!(@company_params)
    @user_params[:company_id] = @company.id
  end

  def create_user
    @user = User.new(@user_params)
    @user.admin = true if @company.present?
    @user.activate
    @user.activated_at = Time.current
    @user.activation_sent_at = Time.current
    @user.save!
    @user
  end
end