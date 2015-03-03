class FormAwardEligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!, :check_account_completion
  before_action :set_form_answer
  before_action :set_steps_and_eligibilities, :setup_wizard
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]

  def show
    #    if award eligibility is not passed
    #      and there's no basic eligibility
    #      or basic eligibility is not eligible
    #      and there's no step

    if (!@award_eligibility.passed? || (@basic_eligibility && !@basic_eligibility.eligible_on_step?(@basic_eligibility.questions.last))) && !params[:id]
      step = if @basic_eligibility && !@basic_eligibility.passed?
        @basic_eligibility.class.questions.first
      else
        @award_eligibility.class.questions.first
      end

      redirect_to action: :show, form_id: @form_answer.id, id: step, skipped: true
      return
    end

    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
  end

  def update
    @eligibility.current_step = step
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
    if @eligibility.update(eligibility_params)
      if step == @eligibility.questions.last
        @eligibility.pass!
      end

      if @eligibility.eligible?
        set_steps_and_eligibilities
        setup_wizard
        if params[:skipped] == 'true'
          redirect_to next_wizard_path(form_id: @form_answer.id, skipped: true)
        else
          redirect_to action: :show, form_id: @form_answer.id
        end
      else
        redirect_to result_form_award_eligibility_url(form_id: @form_answer.id)
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
