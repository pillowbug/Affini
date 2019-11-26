class UserPolicy < ApplicationPolicy
  def dashboard?
    user && (record.id == user.id)
  end

  def show?
    user && (record.id == user.id || user&.admin?)
  end

  def create?
    true
  end

  def update?
    user && (record.id == user.id || user&.admin?)
  end

  def destroy?
    user && (record.id == user.id || user&.admin?)
  end

  class Scope < Scope
    def resolve
      User.none
    end
  end
end
