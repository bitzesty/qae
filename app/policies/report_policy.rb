class ReportPolicy < ApplicationPolicy
  def show?
    admin?
  end
end
