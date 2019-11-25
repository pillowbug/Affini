class ConnectionMailPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def send_connection_email?
    true
  end
end
