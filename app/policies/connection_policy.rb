class ConnectionPolicy < ApplicationPolicy
  def show?
    record.user == user || user.admin?
  end

  def create?
    true
  end

  def send_connection_email?
    true
  end

  def update?
    record.user == user || user.admin?
  end

  def destroy?
    record.user == user || user.admin?
  end

  def onboard_update?
    record.user == user || user.admin?
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
