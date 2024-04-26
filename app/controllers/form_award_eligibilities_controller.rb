class FormAwardEligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!, :check_account_completion,
                :check_number_of_collaborators
  before_action :set_form_answer
  before_action :set_steps_and_eligibilities, :setup_wizard
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]
  before_action do
    allow_assessor_access!(@form_answer)
  end

  def show
    #    if award eligibility is not passed
    #      and there's no basic eligibility
    #      or basic eligibility is not eligible
    #      and there's no step

    if !params[:id] &&
      (@form_answer.promotion? ||
      (@basic_eligibility && (@basic_eligibility.eligible? || @basic_eligibility.answers.none?))) &&
      (@award_eligibility.eligible? || @award_eligibility.answers.none?)

      step = nil

      if @basic_eligibility &&
        (@basic_eligibility.answers.none? ||
         @basic_eligibility.questions.size != @basic_eligibility.answers.size)

        step = @basic_eligibility.questions.first
      elsif @award_eligibility.answers.none?
        step = @award_eligibility.questions.first
      end

      if step.blank? && params[:force_validate_now].present?
        @award_eligibility.force_validate_now = true
        @award_eligibility.valid?

        step = @award_eligibility.errors.keys.first
      end

      if step
        redirect_to action: :show, form_id: @form_answer.id, id: step, skipped: false
        return
      end
    end

    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
  end

  def update
    @eligibility.current_step = step
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
    if @eligibility.update(eligibility_params)
      @award_eligibility.force_validate_now = true

      if @eligibility.any_error_yet?
        @form_answer.state_machine.perform_simple_transition("not_eligible")
      else
        @form_answer.state_machine.after_eligibility_step_progress
      end

      if step == @eligibility.questions.last
        @eligibility.pass!
      end

      check_passed_award_eligibility_after_changing_answer!

      if params[:skipped] == "false" || !@award_eligibility.valid?
        set_steps_and_eligibilities
        setup_wizard

        if @eligibility.eligible_on_step?(step)
          redirect_to next_wizard_path(form_id: @form_answer.id, skipped: false)
        else
          redirect_to action: :show, form_id: @form_answer.id
        end
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

  def warning
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
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

  def check_passed_award_eligibility_after_changing_answer!
    if @basic_eligibility.passed? && @award_eligibility.passed?
      # We need to check validations it in case if user changed answer
      # after passing of validation
      #
      @award_eligibility.force_validate_now = true

      # Mark eligibility as not passed in case if answer was changed
      # and now eligibility is not valid!
      #
      @award_eligibility.update_column(:passed, false) if !@award_eligibility.valid?
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
