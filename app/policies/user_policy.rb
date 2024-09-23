# this policy is used to make sure that no user outside of 
# the company can perform actions on the users of the company
# also an admin can view, update and delete only other users of the same company
class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    (user.company_id == record.company_id) && (user.admin? || user == record)
  end

  def create?
    true
  end

  def update?
    (user.company_id == record.company_id) && (user.admin? || user == record)
  end

  def destroy?
    (user.company_id == record.company_id) && (user.admin? || user == record)
  end

  class Scope < Scope
    def resolve
      return scope.where(company_id: user.company_id) if user && user.company_id
      scope.none
    end
  end
end
