class Assessor::BaseController < ApplicationController
  include Pundit

  layout "application-assessor"

  before_action :authenticate_assessor!, :load_award_year_and_settings
  before_action :check_suspension_status
  after_action :verify_authorized

  skip_before_action :authenticate_user!, raise: false
  skip_before_action :restrict_access_if_admin_in_read_only_mode!, raise: false

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_assessor
  end

  def current_subject
    current_assessor
  end

  def render_flash_message_for(resource, message: nil)
    if resource.errors.any?
      flash.now[:error] = message || "An unknown error has occurred, please try again."
    else
      flash[:notice] = message || "Success!"
    end
  end

  private

  helper_method :namespace_name, :current_subject

  def namespace_name
    :assessor
  end

  def user_not_authorized
    flash.alert = "You are not authorized to perform this action."
    redirect_to(assessor_root_path)
  end

  def user_for_paper_trail
    "ASSESSOR:#{current_assessor.id}" if current_assessor.present?
  end

  def check_suspension_status
    if current_assessor.suspended? && controller_name != "dashboard" && action_name != "suspended"
      flash.clear # clearing any successfull login messages
      redirect_to assessor_suspended_path
    end
  end
end
