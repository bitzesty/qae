class AuditEvent
  attr_accessor :form_answer, :action_type, :subject, :created_at

  def initialize(form_answer:, action_type:, subject:, created_at:)
    @form_answer = form_answer
    @action_type = action_type
    @subject = subject
    @created_at = created_at
  end

  def to_s
    "On #{date_string} at #{time_string} #{user_string} #{description_for_action_type(action_type)}"
  end

  private

  def date_string
    created_at.in_time_zone("London").strftime("%d/%m/%Y")
  end

  def time_string
    created_at.in_time_zone("London").strftime("%H:%M")
  end

  def description_for_action_type(action_type)
    I18n.t("audit_logs.action_types.#{action_type}")
  end

  def user_string
    user_type = subject.instance_of?(::User) ? "Applicant" : subject.class.name
    "#{subject.full_name} (#{user_type})"
  end
end
