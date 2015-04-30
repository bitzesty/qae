class Admin::CustomEmailsController < Admin::BaseController
  def show
    authorize :custom_email, :show?
  end
end
