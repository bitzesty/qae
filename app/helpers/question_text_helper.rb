module QuestionTextHelper
  def interpolate_deadlines(text)
    text.gsub(
      "[AUDIT_CERTIFICATES_DEADLINE]",
      audit_certificates_deadline.decorate.formatted_trigger_time
    ).gsub(
      "[AUDIT_CERTIFICATES_SOCIAL_MOBILITY_DEADLINE]",
      audit_certificates_social_mobility_deadline.decorate.formatted_trigger_time
    )
  end

  def audit_certificates_deadline
    Settings.current_audit_certificates_deadline
  end

  def audit_certificates_social_mobility_deadline
    Settings.current_audit_certificates_social_mobility_deadline
  end
end
