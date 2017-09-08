class Assessor::SessionChecksController < ActionController::Base
  include SessionStatusCheckMixin

  private

  def namespace
    "assessors"
  end
end
