class PressSummaryPolicy < ApplicationPolicy
  def create?
    admin? || (assessor? && subject.assigned?(form_answer))
  end

  def update?
    return @can_update unless @can_update.nil?

    @can_update = if assessor?
      subject.lead?(form_answer) || (subject.assigned?(form_answer) && !record.submitted?)
    else
      admin?
    end
  end
  alias :create? :update?

  def approve?
    return @can_approve unless @can_approve.nil?

    @can_approve = if assessor?
      subject.lead?(form_answer) && !record.approved?
    else
      admin? && !record.approved?
    end
  end

  def submit?
    return @can_submit unless @can_submit.nil?

    @can_submit = !record.submitted? && assessor? && subject.primary?(form_answer)
  end

  def unlock?
    return @can_unlock unless @can_unlock.nil?

    @can_unlock = record.submitted? &&
      (admin? || (assessor? && subject.lead?(form_answer)))
  end

  private

  def form_answer
    record.form_answer
  end
end
