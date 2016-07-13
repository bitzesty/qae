class AuditLogPolicy < ApplicationPolicy
  def index?
    admin?
  end
end
