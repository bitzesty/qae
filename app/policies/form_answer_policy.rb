class FormAnswerPolicy < ApplicationPolicy
  def index?
    admin? || assessor?
  end

  def show_section_appraisal_moderated?
    subject.lead?(record) ||
      (record.assessor_assignments.moderated.submitted? && subject.primary?(record))
  end

  def review?
    record.award_year.current? &&
    (
      admin? ||
      subject.lead_or_assigned?(record)
    )
  end

  def show?
    admin? || assessor?
  end

  def edit?
    deadline = record.award_year.settings.winners_email_notification.try(:trigger_at)
    admin? && subject.superadmin? && (!deadline.present? || DateTime.now <= deadline)
  end

  def update?
    admin? || subject.lead?(record)
  end

  def update_item?(item)
    admin_or_lead_or_primary = admin? || (subject.lead?(record) ||
                               subject.primary?(record))

    if item.in? [:previous_wins, :sic_code]
      admin_or_lead_or_primary
    else
      admin_or_lead_or_primary &&
          record.submitted_and_after_the_deadline? &&
          update?
    end
  end

  def update_company?
    CompanyDetailPolicy.new(subject, record).can_manage_company_name?
  end

  def can_update_by_admin_lead_and_primary_assessors?
    admin? || subject.lead?(record) || subject.primary?(record)
  end

  def update_financials?
    admin? || subject.lead?(record) || subject.primary?(record)
  end

  def assign_assessor?
    admin? || subject.lead?(record)
  end

  def toggle_admin_flag?
    admin?
  end

  def toggle_assessor_flag?
    admin? || subject.lead_or_assigned?(record)
  end

  def download_feedback_pdf?
    admin? && record.submitted? && record.feedback.present?
  end

  def download_case_summary_pdf?
    admin? && record.in_positive_state? && record.lead_or_primary_assessor_assignments.any?
  end

  def download_audit_certificate_pdf?
    (admin? || subject.lead_or_assigned?(record)) &&
    record.audit_certificate.present? &&
    record.audit_certificate.attachment.present? &&
    record.audit_certificate.clean?
  end

  def remove_audit_certificate?
    admin? && record.audit_certificate.present?
  end

  def has_access_to_post_shortlisting_docs?
    download_feedback_pdf? ||
    download_case_summary_pdf? ||
    download_audit_certificate_pdf?
  end

  def can_download_initial_audit_certificate_pdf?
    admin? && !record.promotion? && record.shortlisted?
  end

  def can_see_corp_responsibility?
    record.business? && record.shortlisted?
  end

  def can_review_corp_responsibility?
    can_see_corp_responsibility? &&
    can_update_by_admin_lead_and_primary_assessors?
  end

  def can_download_original_pdf_of_application_before_deadline?
    can_update_by_admin_lead_and_primary_assessors? &&
    record.submitted? &&
    record.submission_ended? &&
    record.pdf_version.present?
  end

  def can_add_collaborators_to_application?
    admin?
  end
end
