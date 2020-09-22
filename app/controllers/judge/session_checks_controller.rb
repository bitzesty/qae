class Judge::SessionChecksController < ActionController::Base
  include SessionStatusCheckMixin

  private

  def namespace
    JUDGE_NAMESPACE
  end
end
