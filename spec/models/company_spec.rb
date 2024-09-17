require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'associations' do
    it { should have_many(:users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:timezone) }
    it { should validate_presence_of(:work_week_start) }
  end

  describe 'enums' do
    it { should define_enum_for(:work_week_start).with_values(monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6) }
  end
end