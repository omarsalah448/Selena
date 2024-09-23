require 'rails_helper'

RSpec.describe VacationPolicy, type: :policy do
  subject { described_class }

  let(:admin) { create(:user, admin: true) }
  let(:regular_user) { create(:user) }
  let(:vacation) { create(:vacation) }

  permissions :create?, :update?, :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, vacation)
    end

    it 'denies access if user is not admin' do
      expect(subject).not_to permit(regular_user, vacation)
    end
  end
end