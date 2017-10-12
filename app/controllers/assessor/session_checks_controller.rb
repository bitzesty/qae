class Assessor::SessionChecksController < ActionController::Base
  include SessionStatusCheckMixin

  private

  def namespace
    ASSESSOR_NAMESPACE
  end
end
