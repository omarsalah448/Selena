# this policy is used to make sure that only admins
# can create, update and delete vacations, also any user
# can view their own vacations, and admins can view all vacations
class VacationPolicy < ApplicationPolicy
  def show?
    user.admin? || record.user_id == user.id
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end