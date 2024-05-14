class FeedbackPolicy < ApplicationPolicy
  def update?
    return @can_update unless @can_update.nil?
    return false if record.locked?

    @can_update = if assessor?
      subject.lead?(form_answer) || subject.assigned?(form_answer)
    else
      admin?
    end
  end
  alias_method :create?, :update?

  def submit?
    return @can_submit unless @can_submit.nil?

    @can_submit = if assessor?
      subject.lead?(form_answer) || subject.assigned?(form_answer)
    else
      admin?
    end
  end

  def unlock?
    if assessor?
      subject.lead?(form_answer) && record.submitted? && record.locked? && !Settings.unsuccessful_stage?
    else
      admin? && record.submitted? && record.locked?
    end
  end

  def can_be_submitted?
    submit? && !record.submitted?
  end

  def can_be_re_submitted?
    !record.locked? &&
      submit? &&
      record.submitted?
  end

  private

  def form_answer
    record.form_answer
  end
end
