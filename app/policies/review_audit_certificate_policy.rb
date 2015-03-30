class ReviewAuditCertificatePolicy < ApplicationPolicy
  def create?
    fa = record.form_answer
    admin? || subject.lead?(fa) || subject.primary?(fa)
  end
end
