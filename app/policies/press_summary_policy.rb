class PressSummaryPolicy < ApplicationPolicy
  def create?
    subject.lead_or_assigned?(form_answer)
  end

  def update?
    !record.submitted? && subject.lead_or_assigned?(form_answer)
  end

  alias :create? :update?

  def approve?
    !record.approved? && subject.lead?(form_answer)
  end

  def submit?
    !record.submitted? && subject.lead_or_assigned?(form_answer)
  end

  def unlock?
    record.submitted? && subject.lead?(form_answer) && !Settings.winners_stage?
  end

  def can_see_contact_details?
    record.reviewed_by_user? || deadline_passed?
  end

  def can_update_contact_details?
    ( !deadline_passed? && update? ) || admin?
  end

  def deadline_passed?
    Settings.current
            .deadlines
            .where(kind: "buckingham_palace_confirm_press_book_notes")
            .first
            .passed?
  end

  private

  def form_answer
    record.form_answer
  end
end
