class Admin::BaseController < ApplicationController
  include Pundit
  helper_method :namespace_name

  layout "application-admin"

  before_action :authenticate_admin!
  after_action :verify_authorized

  skip_before_action :authenticate_user!
  skip_before_action :restrict_access_if_admin_in_read_only_mode!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_admin
  end

  private

  def namespace_name
    :assessor
  end

  def user_not_authorized
    flash.alert = "You are not authorized to perform this action."
    redirect_to(admin_dashboard_index_path)
  end
end
