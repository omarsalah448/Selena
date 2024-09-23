class ActivateUser
  def initialize(**params)
    @activate_params = params[:activate_params]
    @user = User.find(params[:user_id])
  end

  def call
    raise "Invalid activation token" unless @user.authenticated?(:activation, @activate_params[:activation_token])
    raise "User already activated" if @user.activated?
    User.transaction do
      update_password
      activate_user
    end
    @user
  end
  private
  def activate_user
    @user.activate
  end
  def update_password
    @user.update!(password: @activate_params[:password], password_confirmation: @activate_params[:password_confirmation])
  end
end
