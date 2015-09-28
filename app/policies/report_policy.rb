class ReportPolicy < ApplicationPolicy
  def show?
    admin? || subject.lead_for_any_category?
  end
end
