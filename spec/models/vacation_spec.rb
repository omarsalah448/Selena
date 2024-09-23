require 'rails_helper'

RSpec.describe Vacation, type: :model do
  let(:user) { create(:user) }
  let(:vacation) { build(:vacation, user: user) }

  it "is valid with a date today or in the future" do
    vacation.date = Date.today
    expect(vacation).to be_valid
  end

  it "is not valid with a date in the past" do
    vacation.date = Date.yesterday
    expect(vacation).not_to be_valid
    expect(vacation.errors[:date]).to include("can't be in the past")
  end

  it "is valid with valid attributes" do
    expect(vacation).to be_valid
  end

  it "is not valid with a start date in the past" do
    vacation.start_date = Date.yesterday
    expect(vacation).to_not be_valid
  end

  it "is not valid with an end date before the start date" do
    vacation.start_date = Date.today
    vacation.end_date = Date.yesterday
    expect(vacation).to_not be_valid
  end

  describe "scopes" do
    describe ".overlapping" do
      let!(:vacation1) { create(:vacation, start_date: "2023-06-01", end_date: "2023-06-07") }
      let!(:vacation2) { create(:vacation, start_date: "2023-06-05", end_date: "2023-06-10") }
      let!(:vacation3) { create(:vacation, start_date: "2023-06-15", end_date: "2023-06-20") }

      it "returns vacations that overlap with the given date range" do
        result = described_class.overlapping("2023-06-03", "2023-06-08")
        expect(result).to contain_exactly(vacation1, vacation2)
      end

      it "does not return vacations outside the given date range" do
        result = described_class.overlapping("2023-06-11", "2023-06-14")
        expect(result).to be_empty
      end
    end
  end
end