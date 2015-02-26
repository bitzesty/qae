class ReportPolicy < ApplicationPolicy
  def show?
    admin.admin?
  end
end
