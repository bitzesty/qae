class Users::DeclarationOfResponsibilitiesController < Users::BaseController
  before_action :load_form_answer, :load_form

  def update
    if @declaration_form.update(params[:declaration_of_responsibility_form])
      redirect_to dashboard_url, notice: "Declaration of corporate responsibility was successfully saved"
    else
      render :edit
    end
  end

  private

  def load_form_answer
    @form_answer = current_account.form_answers.find(params[:form_answer_id])
  end

  def load_form
    @declaration_form = DeclarationOfResponsibilityForm.new(@form_answer)
  end
end
