module Tokenable
  extend ActiveSupport::Concern

  class_methods do
    def generate_token
      SecureRandom.urlsafe_base64
    end

    def digest_token(token)
      BCrypt::Password.create(token)
    end

    def check_token(token, digest)
      BCrypt::Password.new(digest).is_password?(token)
    end
  end

  def generate_token(attribute)
    token = self.class.generate_token
    digest = self.class.digest_token(token)
    self.send("#{attribute}_token=", token)
    self.send("#{attribute}_digest=", digest)
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    self.class.check_token(token, digest)
  end
end