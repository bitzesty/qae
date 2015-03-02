class AdminPolicy < UserPolicy
  def destroy?
    admin? && subject != record
  end
end
