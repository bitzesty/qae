class FormAnswerAuditor
  include AuditHelper

  def initialize(form_answer)
    @form_answer = form_answer
  end

  def get_audit_events
    events = create_events_from_audit_logs(@form_answer) + create_events_from_papertrail_versions(@form_answer)
    events.sort_by(&:created_at)
  end

  private

  def create_events_from_audit_logs(form_answer)
    form_answer.audit_logs.preload(:subject).data_update.map do |audit_log|
      AuditEvent.new(
        form_answer:,
        action_type: audit_log.action_type,
        subject: audit_log.subject || dummy_user,
        created_at: audit_log.created_at,
      )
    end
  end

  def create_events_from_papertrail_versions(form_answer)
    form_answer.versions.map do |version|
      AuditEvent.new(
        form_answer:,
        action_type: "application_#{version.event}",
        subject: get_user_from_papertrail_version(version),
        created_at: version.created_at,
      )
    end
  end

  def get_user_from_papertrail_version(version)
    return dummy_user if version.whodunnit.nil?

    klass, id = version.whodunnit.split(":")
    klass.capitalize.constantize.find_by(id:) || dummy_user
  end
end
