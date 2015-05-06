class Admin::CustomEmailsController < Admin::BaseController
  def show
    authorize :custom_email, :show?
    @form = CustomEmailForm.new(user: current_admin)
  end

  def create
    authorize :custom_email, :create?

    @form = CustomEmailForm.new(params[:cutom_email_form].merge(user: current_admin))
    if @form.valid?
      @form.send!
      redirect_to admin_custom_email_path, notice: "Email was successfully sent"
    else
      render :show
    end
  end
end
