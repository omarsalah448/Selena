require "jwt"

module JwtAuthenticatable
  extend ActiveSupport::Concern

  included do
    attr_accessor :headers
  end

  def decoded_auth_token
    JWT.decode(auth_token, Rails.application.credentials.secret_key_base)[0]
  end

  def auth_token
    return headers["Authorization"].split.last if headers["Authorization"].present?
    raise("Missing Token")
  end
end
