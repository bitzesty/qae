class CompanyDetailPolicy < ApplicationPolicy
  def update?
    admin? || subject.lead?(record.form_answer)
  end

  def can_manage_company_name?
    admin?
  end

  def can_manage_address?
    if admin?
      record.submitted_and_after_the_deadline? || subject.superadmin?
    end
  end
end
