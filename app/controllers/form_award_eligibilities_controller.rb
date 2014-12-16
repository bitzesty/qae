class FormAwardEligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!, :check_basic_eligibility, :check_award_eligibility, :check_account_completion
  before_action :set_form_answer
  before_action :set_steps_and_eligibilities, :setup_wizard
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]

  def update
    @eligibility.current_step = step

    if @eligibility.update!(eligibility_params)
      redirect_to action: :show, form_id: @form_answer.id
      return
    else
      render :show
    end
  end

  def result
    if @form_answer.eligible?
      redirect_to edit_form_url(@form_answer)
    else
      redirect_to public_send("#{@form_answer.award_type}_award_eligible_failure_path")
    end

    return
  end

  private

  def set_form_answer
    @form_answer = FormAnswer.for_account(current_user.account).find(params[:form_id])
  end

  def set_steps_and_eligibilities
    builder = FormAnswer::AwardEligibilityBuilder.new(@form_answer)
    @award_eligibility = builder.eligibility
    @basic_eligibility =  builder.basic_eligibility

    if @basic_eligibility.questions.map(&:to_s).include?(params[:id])
      @eligibility = @basic_eligibility
      self.steps = [params[:id].to_sym] + @award_eligibility.questions
    else
      @eligibility = @award_eligibility
      self.steps = @award_eligibility.class.questions
    end
  end

  def eligibility_params
    if params[:eligibility]
      params.require(:eligibility).permit(*@eligibility.questions)
    else
      {}
    end
  end
end
