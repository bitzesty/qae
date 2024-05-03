class PressSummaryPolicy < ApplicationPolicy
  def create?
    subject.lead_or_assigned?(form_answer)
  end

  def update?
    (!record.submitted? && subject.lead_or_assigned?(form_answer)) || admin?
  end

  alias create? update?

  def approve?
    !record.approved? && subject.lead?(form_answer)
  end

  def submit?
    !record.submitted? && subject.lead_or_assigned?(form_answer)
  end

  def unlock?
    record.submitted? && subject.lead?(form_answer) && !on_winners_stage?
  end

  def admin_signoff?
    admin? && on_winners_stage?
  end

  def can_update_contact_details?
    (!deadline_passed? && update?) || admin?
  end

  def deadline_passed?
    settings.deadlines
            .buckingham_palace_confirm_press_book_notes
            .passed?
  end

  private

  def form_answer
    record.form_answer
  end

  def on_winners_stage?
    @winners_email ||= settings.winners_email_notification
    @winners_email && @winners_email.passed?
  end

  def settings
    if form_answer && form_answer.award_year
      form_answer.award_year.settings
    else
      # new records
      Settings.current
    end
  end
end
