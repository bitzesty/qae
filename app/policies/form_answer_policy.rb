class FormAnswerPolicy < ApplicationPolicy
  def index?
    admin.admin?
  end
end
