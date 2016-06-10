require "app_responder"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  ensure_security_headers if ENV["ENSURE_SECURITY_HEADERS"]

  before_filter :configure_permitted_parameters, if: :devise_controller?

  self.responder = AppResponder
  respond_to :html

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      custom_redirect_url = session[:custom_redirect]

      if custom_redirect_url.present?
        session[:custom_redirect] = nil
        custom_redirect_url
      else
        dashboard_path
      end
    else
      super
    end
  end

  def admin_in_read_only_mode?
    @admin_in_read_only_mode ||= (admin_signed_in? || assessor_signed_in?) &&
                                 session["warden.user.user.key"] &&
                                 session[:admin_in_read_only_mode]
  end
  helper_method :admin_in_read_only_mode?

  def restrict_access_if_admin_in_read_only_mode!
    if admin_in_read_only_mode?
      if request.referer
        redirect_to :back, alert: "You have no permissions!"
      else
        render text: "You have no permissions!"
      end
      return
    end
  end

  def allow_assessor_access!(fa)
    if admin_in_read_only_mode?
      if assessor_signed_in? && !admin_signed_in?
        if fa.present?
          if current_assessor.lead_or_assigned?(fa)
            return true
          end
        end
        if request.referer
          redirect_to :back, alert: "You have no permissions!"
        else
          render text: "You have no permissions!"
        end
        return false
      end
    end
  end

  def current_account
    current_user && current_user.account
  end
  helper_method :current_account

  protected

  def settings
    Rails.cache.fetch("current_settings", expires_in: 1.minute) do
      AwardYear.current.settings
    end
  end

  def submission_started?
    submission_started_deadline.passed?
  end
  helper_method :submission_started?

  def submission_ended?
    submission_deadline.passed?
  end
  helper_method :submission_ended?

  def current_form_submission_ended?
    @form_answer.submission_ended?
  end
  helper_method :current_form_submission_ended?

  def submission_started_deadline
    Settings.current_submission_start_deadline
  end
  helper_method :submission_started_deadline

  def submission_deadline
    Settings.current_submission_deadline
  end
  helper_method :submission_deadline

  def audit_certificates_deadline
    Settings.current_audit_certificates_deadline
  end
  helper_method :audit_certificates_deadline

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(
        :email,
        :password,
        :password_confirmation,
        :agreed_with_privacy_policy
      )
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(
        :email,
        :current_password,
        :password,
        :password_confirmation,
        :completed_registration,
        :title,
        :first_name,
        :last_name,
        :job_title,
        :phone_number,
        :company_name,
        :company_address_first,
        :company_address_second,
        :company_city,
        :company_country,
        :company_postcode,
        :company_phone_number,
        :prefered_method_of_contact,
        :subscribed_to_emails,
        :agree_being_contacted_by_department_of_business
      )
    end
  end

  def check_account_completion
    if !current_user.completed_registration?
      redirect_to correspondent_details_account_path
      return
    end
  end

  def require_to_be_account_admin!
    unless current_user.account_admin?
      redirect_to dashboard_path,
                  notice: "Access denied!"
    end
  end

  def load_award_year_and_settings
    if params[:year] && AwardYear::AVAILABLE_YEARS.include?(params[:year].to_i)
      @award_year = AwardYear.for_year(params[:year].to_i).first_or_create
    else
      @award_year = AwardYear.current
    end

    @settings = @award_year.settings
    @deadlines = @settings.deadlines.to_a
  end

  def user_for_paper_trail
    "USER:#{current_user.id}" if current_user.present?
  end

  #
  # Validate applications number per account - BEGIN
  # used in multiple controllers
  #

  def check_trade_count_limit
    check_applications_limit(:trade)
  end

  def check_development_count_limit
    check_applications_limit(:development)
  end

  def check_applications_limit(type_of_award)
    if current_account.has_award_in_this_year?(type_of_award)
      redirect_to dashboard_url, flash: {
        alert: "You can not submit more than one #{type_of_award} form per year!"
      }
    end
  end

  #
  # Validate applications number per account - END
  # used in multiple controllers
  #
end
