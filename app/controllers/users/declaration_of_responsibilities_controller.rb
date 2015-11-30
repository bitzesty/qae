class Users::DeclarationOfResponsibilitiesController < Users::BaseController
  before_action :load_form_answer,
                :load_form,
                :require_application_to_be_business_and_shortlisted!,
                :require_application_to_have_short_dcr_selected!,
                :require_to_have_missing_corp_responsibility!

  before_action :require_to_fill_all_required_questions_to_submit!, only: [:update]

  expose(:submit_declaration) do
    params[:submit_declaration].present?
  end

  expose(:full_dcr_selected?) do
    @form_answer.decorate.full_dcr_selected?
  end

  expose(:short_dcr_selected?) do
    @form_answer.decorate.short_dcr_selected?
  end

  expose(:corp_responsibility_missing?) do
    @form_answer.decorate.corp_responsibility_missing?
  end

  def update
    if @declaration_form.update(params[:declaration_of_responsibility_form])
      if submit_declaration && !corp_responsibility_missing?
        @form_answer.document["corp_responsibility_form"] = "complete_now"
        @form_answer.save!
      end

      if full_dcr_selected?
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

  def require_application_to_be_business_and_shortlisted!
    if !@form_answer.business? || !@form_answer.shortlisted?
      redirect_to dashboard_url, notice: "This section available for shortlisted forms only!"
      return false
    end
  end

  def require_application_to_have_short_dcr_selected!
    unless short_dcr_selected?
      redirect_to dashboard_url,
                  notice: "Available for short DCR selected only!"
      return false
    end
  end

  def require_to_fill_all_required_questions_to_submit!
    if submit_declaration && corp_responsibility_missing?
      redirect_to dashboard_url,
                  notice: "You have to answer on all questions in order to submit declaration!"
      return false
    end
  end

  def require_to_have_missing_corp_responsibility!
    if full_dcr_selected?
      redirect_to dashboard_url, notice: "Declaration already submitted!"
      return false
    end
  end
end
