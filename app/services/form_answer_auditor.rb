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
    form_answer.audit_logs.data_update.map do |audit_log|
      AuditEvent.new(
        form_answer: form_answer,
        action_type: audit_log.action_type,
        subject: audit_log.subject || dummy_user,
        created_at: audit_log.created_at
        )
    end
  end

  def create_events_from_papertrail_versions(form_answer)
    form_answer.versions.map do |version|
      AuditEvent.new(
        form_answer: form_answer,
        action_type: create_action_type_from_paper_trail(version),
        subject: get_user_from_papertrail_version(version),
        created_at: version.created_at
        )
    end
  end

  def get_user_from_papertrail_version(version)
    return dummy_user if version.whodunnit.nil?
    klass, id = version.whodunnit.split(":")
    klass.capitalize.constantize.find_by_id(id) || dummy_user
  end

  def create_action_type_from_paper_trail(version)
    unlogged_actions = [:document, :financial_data, :primary_assessor_id, :secondary_assessor_id]
    form_section = unlogged_actions.select {|action| version.changeset.has_key? action}.join
    form_section.empty? ? "application_#{version.event}" : "#{form_section}_#{version.event}" 
  end

end
