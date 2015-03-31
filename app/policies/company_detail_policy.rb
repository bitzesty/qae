class CompanyDetailPolicy < ApplicationPolicy
  def update?
    admin? || subject.lead?(record)
  end
end
