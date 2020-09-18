class CaseSummaryPolicy < ApplicationPolicy
  def index?
    judge?
  end
end
