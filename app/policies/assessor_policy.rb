class AssessorPolicy < AdminPolicy
  def activate?
    admin?
  end

  def deactivate?
    admin?
  end
end
