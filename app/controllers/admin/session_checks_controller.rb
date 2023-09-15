class Admin::SessionChecksController < ActionController::Base
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
    ADMIN_NAMESPACE
  end
end
