class AuditService
  def get_logs_for_form_answer(form_answer)
    logs = form_answer.audit_logs + create_logs_from_papertrail_versions(form_answer)
    logs.sort_by(&:created_at)
  end

  private

  def create_logs_from_papertrail_versions(form_answer)
    form_answer.versions.map do |version|
      AuditLog.new(
        auditable_type: "FormAnswer",
        auditable_id: form_answer.id,
        action_type: "application_update",
        subject: get_user_from_papertrail_version(version),
        created_at: version.created_at
        )
    end
  end

  def get_user_from_papertrail_version(version)
    klass, id = version.whodunnit.split(":")
    klass.capitalize.constantize.find_by_id(id)
  end

end
