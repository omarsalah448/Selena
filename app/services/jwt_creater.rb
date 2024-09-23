class JwtCreater
  def initialize(**params)
    @user = params[:user]
    @device_id = params[:device_id]
  end

  def call
    raise "User not found" unless @user.present?
    raise "Device ID not found" unless @device_id.present?
    JWT.encode({ user_id: @user.id, device_id: @device_id, exp: 1.day.from_now.to_i }, Rails.application.credentials.secret_key_base)
  end
end