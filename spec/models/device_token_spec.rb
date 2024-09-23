require "rails_helper"

RSpec.describe DeviceToken, type: :model do
  let(:device_token) { build(:device_token) }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:token) }
    it { should validate_uniqueness_of(:token) }
    it { should validate_presence_of(:device_id) }
    it { should validate_uniqueness_of(:device_id).scoped_to(:user_id) }
  end

  describe "callbacks" do
    it "generates token before creation" do
      expect { device_token.save }.to change { device_token.token }.from(nil)
    end

    it "does not change token on update" do
      device_token.save
      original_token = device_token.token
      device_token.update(device_id: "new_device_id")
      expect(device_token.token).to eq(original_token)
    end
  end

  describe "#generate_token" do
    it "generates a unique token" do
      device_token.send(:generate_token)
      expect(device_token.token).to be_present
      expect(device_token.token).to match(/\A[a-zA-Z0-9]{20}\z/)
    end

    it "generates a different token for each device" do
      device_token1 = create(:device_token)
      device_token2 = create(:device_token)
      expect(device_token1.token).not_to eq(device_token2.token)
    end
  end

  describe "scopes" do
    it "orders by created_at in descending order" do
      old_token = create(:device_token, created_at: 1.day.ago)
      new_token = create(:device_token, created_at: 1.hour.ago)
      expect(DeviceToken.all).to eq([new_token, old_token])
    end
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:device_token)).to be_valid
    end
  end

  describe "token expiration" do
    it "is not expired when created" do
      expect(create(:device_token)).not_to be_expired
    end

    it "is expired after 30 days" do
      device_token = create(:device_token, created_at: 31.days.ago)
      expect(device_token).to be_expired
    end
  end

  describe "#refresh_token" do
    it "generates a new token" do
      device_token.save
      old_token = device_token.token
      device_token.refresh_token
      expect(device_token.token).not_to eq(old_token)
    end

    it "updates the created_at timestamp" do
      device_token.save
      old_timestamp = device_token.created_at
      Timecop.travel(1.day.from_now) do
        device_token.refresh_token
        expect(device_token.created_at).to be > old_timestamp
      end
    end
  end

  describe ".cleanup_expired_tokens" do
    it "removes expired tokens" do
      create(:device_token, created_at: 31.days.ago)
      create(:device_token, created_at: 29.days.ago)
      expect { DeviceToken.cleanup_expired_tokens }.to change { DeviceToken.count }.by(-1)
    end
  end
end