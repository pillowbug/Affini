class ConnectionPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def create?
    true
  end

  def send_connection_email?
    true
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
