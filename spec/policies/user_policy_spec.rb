require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class }

  let(:admin) { create(:user, admin: true) }
  let(:regular_user) { create(:user) }
  let(:other_user) { create(:user) }

  permissions :index? do
    it 'denies access if not admin' do
      expect(subject).not_to permit(regular_user, User)
    end

    it 'allows access if admin' do
      expect(subject).to permit(admin, User)
    end
  end

  permissions :show? do
    it 'allows access if admin' do
      expect(subject).to permit(admin, other_user)
    end

    it 'allows access if user is viewing their own profile' do
      expect(subject).to permit(regular_user, regular_user)
    end

    it 'denies access if user is not admin and not viewing their own profile' do
      expect(subject).not_to permit(regular_user, other_user)
    end
  end

  permissions :create? do
    it 'allows access if admin' do
      expect(subject).to permit(admin, User)
    end

    it 'denies access if not admin' do
      expect(subject).not_to permit(regular_user, User)
    end
  end

  permissions :update? do
    it 'allows access if admin' do
      expect(subject).to permit(admin, other_user)
    end

    it 'allows access if user is updating their own profile' do
      expect(subject).to permit(regular_user, regular_user)
    end

    it 'denies access if user is not admin and not updating their own profile' do
      expect(subject).not_to permit(regular_user, other_user)
    end
  end

  permissions :destroy? do
    it 'allows access if admin' do
      expect(subject).to permit(admin, other_user)
    end

    it 'denies access if not admin' do
      expect(subject).not_to permit(regular_user, other_user)
    end
  end
end
