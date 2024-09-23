require "rails_helper"

RSpec.describe TokenHandler do
  describe ".generate" do
    it "generates a URL-safe base64 token" do
      token = TokenHandler.generate
      expect(token).to be_a(String)
      expect(token).to match(/^[A-Za-z0-9\-_]+$/)
    end
  end

  describe ".digest" do
    it "creates a BCrypt hash of the token" do
      token = "sample_token"
      digest = TokenHandler.digest(token)
      expect(digest).to be_a(String)
      expect(digest).to start_with("$2a$")
    end
  end

  describe ".check" do
    it "returns true for a matching token and digest" do
      token = TokenHandler.generate
      digest = TokenHandler.digest(token)
      expect(TokenHandler.check(token, digest)).to be true
    end

    it "returns false for a non-matching token and digest" do
      token = TokenHandler.generate
      digest = TokenHandler.digest(token)
      expect(TokenHandler.check("wrong_token", digest)).to be false
    end
  end
end