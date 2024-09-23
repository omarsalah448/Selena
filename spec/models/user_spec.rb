require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should belong_to(:company).optional }
    it { should have_many(:device_tokens).dependent(:destroy) }
    it { should have_many(:time_logs).dependent(:destroy) }
    it { should have_many(:vacations).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(4).is_at_most(20) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).scoped_to(:activated).case_insensitive }
    it { should allow_value("user@example.com").for(:email) }
    it { should_not allow_value("invalid_email").for(:email) }
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(2).is_at_most(50) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_length_of(:password).is_at_least(6).is_at_most(20).on(:create) }
    it { should validate_length_of(:password_confirmation).is_at_least(6).is_at_most(20).on(:create) }
    it { should validate_presence_of(:company_id).unless(:company) }
  end

  describe "callbacks" do
    it "normalizes phone number before validation" do
      user = User.new(phone_number: "(123) 456-7890")
      user.valid?
      expect(user.phone_number).to eq("+11234567890")
    end

    it "generates activation token before creation" do
      user = build(:user)
      expect { user.save }.to change { user.activation_token }.from(nil)
    end
  end

  describe "#activate" do
    it "activates the user" do
      user = create(:user, activated: false, activated_at: nil)
      user.activate
      expect(user.activated).to be true
      expect(user.activated_at).to be_present
    end
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:company) }
  end

  describe "secure password" do
    it { should have_secure_password }
  end

  describe "phone number validation" do
    it "should validate phone number format" do
      user = build(:user, phone_number: "invalid")
      expect(user).not_to be_valid
      expect(user.errors[:phone_number]).to include("is invalid")
    end

    it "should accept valid phone numbers" do
      user = build(:user, phone_number: "+1 (123) 456-7890")
      expect(user).to be_valid
    end
  end

  describe "tokenable concern" do
    it "should include Tokenable module" do
      expect(User.ancestors).to include(Tokenable)
    end
  end
end