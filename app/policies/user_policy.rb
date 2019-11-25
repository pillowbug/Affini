class UserPolicy < ApplicationPolicy
  def dashboard?
    record.id == user.id
  end

  def show?
    record.id == user.id || user.admin?
  end

  def create?
    true
  end

  def update?
    record.id == user.id || user.admin?
  end

  def destroy?
    record.id == user.id || user.admin?
  end

  class Scope < Scope
    def resolve
      User.none
    end
  end
end
