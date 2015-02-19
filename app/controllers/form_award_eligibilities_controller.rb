class FormAwardEligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!, :check_account_completion
  before_action :set_form_answer
  before_action :set_steps_and_eligibilities, :setup_wizard
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]

  def show
    if (@award_eligibility.skipped? || !@basic_eligibility || !@basic_eligibility.eligible_on_step?(@basic_eligibility.questions.last)) && !params[:id]
      step = !@basic_eligibility || @basic_eligibility.passed? ? @award_eligibility.class.questions.first : @basic_eligibility.class.questions.first
      redirect_to action: :show, form_id: @form_answer.id, id: step, skipped: true
      return
    end

    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
  end

  def update
    @eligibility.current_step = step
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
    if @eligibility.update(eligibility_params)
      if params[:skipped] == 'true' && ((step != @eligibility.questions.last) || @eligibility.is_a?(Eligibility::Basic))
        set_steps_and_eligibilities
        setup_wizard
        redirect_to next_wizard_path(form_id: @form_answer.id, skipped: true)
      else
        redirect_to action: :show, form_id: @form_answer.id
      end

      return
    else
      render :show
    end
  end

  def result
    if @form_answer.eligible?
      redirect_to edit_form_url(@form_answer)
    else
      redirect_to public_send("#{@form_answer.award_type}_award_eligible_failure_path", form_id: @form_answer.id)
    end

    return
  end

  private

  def set_form_answer
    @form_answer = current_account.form_answers.find(params[:form_id])
  end

  def set_steps_and_eligibilities
    builder = FormAnswer::AwardEligibilityBuilder.new(@form_answer)
    @award_eligibility = builder.eligibility
    @basic_eligibility =  builder.basic_eligibility

    if @basic_eligibility && @basic_eligibility.questions.map(&:to_s).include?(params[:id])
      @eligibility = @basic_eligibility

      basic_steps = []
      found = false
      @basic_eligibility.questions.each do |question|
        if found || question == params[:id].to_sym
          basic_steps << question
          found = true
        end
      end

      self.steps = basic_steps + @award_eligibility.questions
    else
      @eligibility = @award_eligibility
      self.steps = @award_eligibility.questions
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
