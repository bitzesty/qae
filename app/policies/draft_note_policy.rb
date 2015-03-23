class DraftNotePolicy < ApplicationPolicy
  def create?
    admin_or_lead_or_assigned?(record.notable)
  end

  def update?
    admin_or_lead_or_assigned?(record.notable)
  end
end
