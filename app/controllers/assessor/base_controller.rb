class Assessor::BaseController < ApplicationController
  include Pundit

  layout "application-assessor"

  before_action :authenticate_assessor!, :load_award_year_and_settings
  after_action :verify_authorized

  skip_before_action :authenticate_user!
  skip_before_action :restrict_access_if_admin_in_read_only_mode!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_assessor
  end

  private

  helper_method :namespace_name, :current_subject

  def namespace_name
    :assessor
  end

  def current_subject
    current_assessor
  end

  def user_not_authorized
    flash.alert = "You are not authorized to perform this action."
    redirect_to(assessor_root_path)
  end
end
