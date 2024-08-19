module SessionStatusCheckMixin
  extend ActiveSupport::Concern

  ADMIN_NAMESPACE = "admins".freeze
  ASSESSOR_NAMESPACE = "assessors".freeze
  JUDGE_NAMESPACE = "judges".freeze

  included do
    protect_from_forgery with: :exception, except: [:extend]

    prepend_before_action :skip_timeout, only: [:show]
  end

  def show
    if session_is_valid?
      head :ok
    else
      head :unauthorized
    end
  end

  def extend
    render json: { elapsed: elapsed }, status: :ok
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
    elsif namespace == JUDGE_NAMESPACE
      judge_signed_in?
    end
  end

  def now
    Time.now.in_time_zone("UTC")
  end

  def elapsed
    session = if namespace == ADMIN_NAMESPACE
      admin_session
    elsif namespace == ASSESSOR_NAMESPACE
      assessor_session
    elsif namespace == JUDGE_NAMESPACE
      judge_session
    end
    (now - (session["last_request_at"] || params["__t"].to_i)).to_i / 1.minute
  end
end
