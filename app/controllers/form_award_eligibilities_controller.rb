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
      if step == @eligibility.questions.last
        @eligibility.pass!
      end

      if params[:skipped] == "false"
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
      redirect_to edit_form_url(@form_answer, current_step: params[:current_step])
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
