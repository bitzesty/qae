class PalaceInvitePolicy < ApplicationPolicy
  def update?
    admin? ||
      subject.lead_or_assigned?(record.form_answer)
  end
end
