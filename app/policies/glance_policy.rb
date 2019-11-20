class GlancePolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    record.connection.user == user
  end

  def destroy?
    record.connection.user == user
  end

  class Scope < Scope
    def resolve
      Glance.none # no need for this
    end
  end
end
