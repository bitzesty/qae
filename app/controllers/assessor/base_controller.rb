class Assessor::BaseController < ApplicationController
  include Pundit

  layout "application-assessor"

  before_action :authenticate_assessor!
  after_action :verify_authorized

  skip_before_action :authenticate_user!
  skip_before_action :restrict_access_if_admin_in_read_only_mode!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_assessor
  end

  private

  helper_method :namespace_name

  def namespace_name
    :assessor
  end
end
