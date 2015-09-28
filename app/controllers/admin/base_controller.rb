class Admin::BaseController < ApplicationController
  include Pundit
  helper_method :namespace_name, :current_subject

  layout "application-admin"

  before_action :authenticate_admin!, :load_award_year_and_settings, :set_paper_trail_whodunnit
  after_action :verify_authorized

  skip_before_action :authenticate_user!
  skip_before_action :restrict_access_if_admin_in_read_only_mode!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_admin
  end

  private

  def user_not_authorized
    flash.alert = "You are not authorized to perform this action."
    redirect_to(admin_dashboard_index_path)
  end

  def namespace_name
    :admin
  end

  def current_subject
    current_admin
  end

  def user_for_paper_trail
    "ADMIN:#{current_admin.id}"
  end
end
