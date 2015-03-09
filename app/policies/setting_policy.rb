class SettingPolicy < ApplicationPolicy
  def show?
    admin?
  end
end
