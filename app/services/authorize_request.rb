class AuthorizeRequest
  include JwtAuthenticatable
  def initialize(**params)
    @headers = params[:headers]
  end

  def call
    user = User.find(decoded_auth_token["user_id"])
    raise("Token expired") unless decoded_auth_token["exp"] > Time.current.to_i
    device_token = user.device_tokens.find_by(device_id: decoded_auth_token["device_id"])
    raise("Invalid token") unless device_token.present?
    user
  end
end