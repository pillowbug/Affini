class UserPolicy < ApplicationPolicy
  def show?
    record.id == user.id
  end

  def create?
    true
  end

  def update?
    record.id == user.id
  end

  def destroy?
    record.id == user.id
  end

  class Scope < Scope
    def resolve
      User.none
    end
  end
end
