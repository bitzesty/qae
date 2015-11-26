class Users::DeclarationOfResponsibilitiesController < Users::BaseController
  before_action :load_form_answer,
                :load_form,
                :require_to_have_missing_corp_responsibility!

  before_action :require_to_fill_all_required_questions_to_submit!, only: [:update]

  expose(:submit_declaration) do
    params[:submit_declaration].present?
  end

  expose(:corp_responsibility_missing?) do
    @form_answer.decorate.corp_responsibility_missing?
  end

  def update
    if @declaration_form.update(params[:declaration_of_responsibility_form])
      if submit_declaration && !corp_responsibility_missing?
        @form_answer.update_column(:corp_responsibility_submitted, true)
      end

      if @form_answer.corp_responsibility_submitted?
        redirect_to dashboard_url, notice: "Declaration of corporate responsibility was successfully submitted"
      else
        flash.now[:notice] = "Declaration of corporate responsibility was successfully saved"
        render :edit
      end
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

  def require_to_fill_all_required_questions_to_submit!
    if submit_declaration && corp_responsibility_missing?
      redirect_to dashboard_url
      return false
    end
  end

  def require_to_have_missing_corp_responsibility!
    if @form_answer.corp_responsibility_submitted?
      redirect_to dashboard_url
      return false
    end
  end
end
