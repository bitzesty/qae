class CompanyDetailPolicy < ApplicationPolicy
  def update?
    admin? || subject.lead?(record.form_answer)
  end
end
