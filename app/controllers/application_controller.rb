require "app_responder"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  self.responder = AppResponder
  respond_to :html

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      dashboard_path
    else
      super
    end
  end

  protected

  def load_eligibilities
    @trade_eligibility = current_user.trade_eligibility || current_user.build_trade_eligibility
    @innovation_eligibility = current_user.innovation_eligibility || current_user.build_innovation_eligibility
    @development_eligibility = current_user.development_eligibility || current_user.build_development_eligibility
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :agreed_with_privacy_policy) }
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :current_password, :password, :password_confirmation,
               :completed_registration,
               :title, :first_name, :last_name,
               :job_title, :phone_number,
               :company_name, :company_address_first, :company_address_second,
               :company_city, :company_country, :company_postcode,
               :company_phone_number,
               :prefered_method_of_contact, :subscribed_to_emails)
    end
  end

  def any_eligibilities_passed?
    [@trade_eligibility, @innovation_eligibility, @development_eligibility].any?(&:passed?)
  end
  helper_method :any_eligibilities_passed?

  def check_basic_eligibility
    if !(current_user.basic_eligibility && current_user.basic_eligibility.passed?)
      redirect_to eligibility_path
      return
    end
  end

  def check_award_eligibility
    if %w[trade_eligibility innovation_eligibility development_eligibility].any? { |eligibility| !current_user.public_send(eligibility) }
      redirect_to award_eligibility_path
      return
    end
  end

  def check_account_completion
    if !current_user.completed_registration?
      redirect_to correspondent_details_account_path
      return
    end
  end
end
