# rubocop:disable Rails/ApplicationController
class Assessor::SessionChecksController < ActionController::Base
  include SessionStatusCheckMixin

  def show
    if session_is_valid?
      render json: { elapsed: elapsed }, status: :ok
    else
      head :unauthorized
    end
  end

  def extend
    super
  end

  private

  def namespace
    ASSESSOR_NAMESPACE
  end
end
# rubocop:enable Rails/ApplicationController
