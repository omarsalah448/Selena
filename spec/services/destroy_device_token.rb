require "rails_helper"

RSpec.describe DestroyDeviceToken, type: :service do
  let(:user) { create(:user) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }
  let(:token) { JWT.encode({ device_id: "12345" }, Rails.application.credentials.secret_key_base) }
  let!(:device_token) { user.device_tokens.create(device_id: "12345") }

  subject { described_class.new(user: user, headers: headers) }

  describe "#call" do
    it "destroys the device token" do
      expect { subject.call }.to change { user.device_tokens.count }.by(-1)
    end
  end
end
