class Admin::BaseController < ApplicationController
  include Pundit
  helper_method :namespace_name, :current_subject

  layout "application-admin"

  before_action :authenticate_admin!, :load_award_year_and_settings
  after_action :verify_authorized

  skip_before_action :authenticate_user!, raise: false
  skip_before_action :restrict_access_if_admin_in_read_only_mode!, raise: false

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_admin
  end

  def current_subject
    current_admin
  end

  def render_flash_message_for(resource, message: nil)
    if resource.errors.any?
      flash.now[:error] = message || "An unknown error has occurred, please try again."
    else
      flash[:notice] = message || "Success!"
    end
  end

  private

  def user_not_authorized
    flash.alert = "You are not authorized to perform this action."
    redirect_to(admin_dashboard_index_path)
  end

  def namespace_name
    :admin
  end

  def user_for_paper_trail
    "ADMIN:#{current_admin.id}" if current_admin.present?
  end

  def admin_conditional_pdf_response(mode)
    if form_answer.hard_copy_ready_for?(mode)
      if Rails.env.development?
        send_data pdf_hard_copy.file.read,
                  filename: pdf_hard_copy.original_filename,
                  type: "application/pdf",
                  disposition: 'attachment'
      else
        redirect_to pdf_hard_copy.file.url, allow_other_host: true
      end
    else
      send_data pdf_data.render,
                filename: "application_#{mode.pluralize}_#{form_answer.decorate.pdf_filename}",
                type: "application/pdf",
                disposition: 'attachment'
    end
  end
end
