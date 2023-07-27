class Admin::CustomEmailsController < Admin::BaseController
  def show
    authorize :custom_email, :show?
    @form = CustomEmailForm.new(admin_id: current_admin.id)
  end

  def create
    authorize :custom_email, :create?
    custom_email_form_attributes = if params[:custom_email_form].present?
                                     params[:custom_email_form].merge(admin_id: current_admin.id)
                                   else
                                     {}
                                   end

    @form = CustomEmailForm.new(custom_email_form_attributes)
    if @form.valid?
      CustomEmailWorker.perform_async(custom_email_form_attributes)
      render_flash_message_for(@form)
      redirect_to admin_custom_email_path, notice: "Email was successfully scheduled"
    else
      render_flash_message_for(@form)
      render :show
    end
  end
end
