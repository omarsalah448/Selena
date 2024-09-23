require "rails_helper"

RSpec.describe Company, type: :model do
  describe "associations" do
    it { should have_many(:users).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
    it { should validate_presence_of(:timezone) }
    it { should validate_inclusion_of(:timezone).in_array(ActiveSupport::TimeZone.all.map(&:name)) }
    it { should validate_presence_of(:start_day) }
  end

  describe "enums" do
    it { should define_enum_for(:start_day).with_values(sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6) }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:company)).to be_valid
    end
  end

  describe "instance methods" do
    let(:company) { create(:company) }

    describe "#work_week_start_day" do
      it "returns the correct work week start day" do
        expect(company.work_week_start_day).to eq(company.start_day)
      end
    end
  end

  describe "custom error messages" do
    it "returns a custom error message for invalid timezone" do
      company = build(:company, timezone: "Invalid Timezone")
      company.valid?
      expect(company.errors[:timezone]).to include("Invalid Timezone is not a valid timezone")
    end
  end

  describe "dependent destroy" do
    it "destroys associated users when company is destroyed" do
      company = create(:company)
      user = create(:user, company: company)
      expect { company.destroy }.to change(User, :count).by(-1)
    end
  end
end