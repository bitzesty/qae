class Judge::BaseController < ApplicationController
  include Pundit

  layout "application-judge"

  before_action :authenticate_judge!, :load_award_year_and_settings
  after_action :verify_authorized

  skip_before_action :authenticate_user!, raise: false
  skip_before_action :restrict_access_if_admin_in_read_only_mode!, raise: false

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_judge
  end

  private

  helper_method :namespace_name, :current_subject

  def namespace_name
    :judge
  end

  def user_not_authorized
    flash.alert = "You are not authorized to perform this action."
    redirect_to(judge_root_path)
  end
end
