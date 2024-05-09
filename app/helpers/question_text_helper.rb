module QuestionTextHelper
  def interpolate_deadlines(text)
    text.to_s.gsub(
      "[AUDIT_CERTIFICATES_DEADLINE]",
      audit_certificates_deadline.decorate.formatted_trigger_time,
    )
  end

  def audit_certificates_deadline
    Settings.current_audit_certificates_deadline
  end
end
