module SessionStatusCheckMixin
  extend ActiveSupport::Concern

  ADMIN_NAMESPACE = "admins".freeze
  ASSESSOR_NAMESPACE = "assessors".freeze

  included do
    protect_from_forgery with: :exception

    prepend_before_action :skip_timeout, only: [:show]
  end

  def show
    if session_is_valid?
      head :ok
    else
      head :unauthorized
    end
  end

  private

  def skip_timeout
    request.env["devise.skip_trackable"] = true
  end

  def session_is_valid?
    if namespace == ADMIN_NAMESPACE
      admin_signed_in?
    elsif namespace == ASSESSOR_NAMESPACE
      assessor_signed_in?
    end
  end
end
