class SettingPolicy < ApplicationPolicy
  def index?
    admin?
  end
end
