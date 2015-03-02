class SettingPolicy < ApplicationPolicy
  def index?
    admin.admin?
  end
end
