class AuthenticateUser
  def initialize(**params)
    @email = params[:email]
    @password = params[:password]
    @device_id = params[:device_id]
  end

  def call
    @user = fetch_user
    @user.device_tokens.find_or_create_by!(device_id: @device_id)
    token = JwtCreater.new(user: @user, device_id: @device_id).call
    [ @user, token ]
  end

  def fetch_user
    @user = User.find_by(email: @email)
    return @user if @user.present? && @user.activated? && @user.authenticate(@password)
    raise "Invalid credentials"
  end
end