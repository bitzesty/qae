class CaseSummaryPolicy < ApplicationPolicy
  def index?
    judge?
  end

  def show?
    judge?
  end
end
