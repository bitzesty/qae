class QuestionnaireController < ApplicationController
  before_filter :authenticate_user!, :check_basic_eligibility, :check_award_eligibility, :check_account_completion, :load_form_answer, :load_questionnaire, :check_form_submission_and_quesitonnaire_completion

  def update
    @questionnaire.completed = true
    if @questionnaire.update(questinnaire_params)
      redirect_to submit_confirm_url(@form_answer)
    else
      render :show
    end
  end

  private

  def load_form_answer
    @form_answer = current_user.form_answers.find(params[:id])
  end

  def load_questionnaire
    @questionnaire = @form_answer.questionnaire || @form_answer.build_questionnaire
  end

  def check_form_submission_and_quesitonnaire_completion
    unless @form_answer.submitted?
      redirect_to edit_form_url(@form_answer)
      return
    end

    if @questionnaire.completed?
      redirect_to submit_confirm_url(@form_answer)
      return
    end
  end

  def questinnaire_params
    params.require(:questionnaire).permit(:payment_usability_rating, :security_rating, :overall_payment_rating, :improvement_proposal)
  end
end
