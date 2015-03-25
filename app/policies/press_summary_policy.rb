class PressSummaryPolicy < ApplicationPolicy
  def create?
    admin? || (assessor? && subject.assigned?(form_answer))
  end

  def update?
    return @can_update unless @can_update.nil?

    @can_update = if assessor?
      subject.lead?(form_answer) || (subject.assigned?(form_answer) && !record.approved?)
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

  private

  def form_answer
    record.form_answer
  end
end
