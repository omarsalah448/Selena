class DestroyDeviceToken
  include JwtAuthenticatable

  def initialize(**params)
    @user = params[:user]
    @headers = params[:headers]
  end

  def call
    @user.device_tokens.find_by(device_id: decoded_auth_token["device_id"]).destroy!
  end
end