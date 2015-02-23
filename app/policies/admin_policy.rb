class AdminPolicy < UserPolicy
  def destroy?
    admin.admin? && admin != record
  end
end
