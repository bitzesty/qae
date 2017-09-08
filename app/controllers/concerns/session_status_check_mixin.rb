module SessionStatusCheckMixin
  extend ActiveSupport::Concern

  included do
    protect_from_forgery with: :exception
    ensure_security_headers if ENV["ENSURE_SECURITY_HEADERS"]

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
    if namespace == "admins"
      admin_signed_in?
    elsif namespace == "assessors"
      assessor_signed_in?
    end
  end
end

