class FeedbackPolicy < ApplicationPolicy
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

  def submit?
    return @can_submit unless @can_submit.nil?

    @can_submit = if assessor?
      !subject.lead?(form_answer) && subject.assigned?(form_answer) && !record.submitted?
    else
      admin? && !record.submitted?
    end
  end

  def approve?
    return @can_approve unless @can_approve.nil?

    @can_approve = if assessor?
      subject.lead?(form_answer) && record.submitted? && !record.approved?
    else
      admin? && record.submitted? && !record.approved?
    end
  end

  private

  def form_answer
    record.form_answer
  end
end
