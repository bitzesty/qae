class EligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :load_eligibility, :set_steps, :setup_wizard
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]

  def show
    unless step
      redirect_to wizard_path(:kind)
      return
    end
  end

  def update
    @eligibility.current_step = step
    if @eligibility.update(eligibility_params)
      set_steps
      setup_wizard

      if @eligibility.eligible?
        if step == @eligibility.questions.last
          redirect_to award_eligibility_path
        else
          redirect_to next_wizard_path
        end
      else
        redirect_to failure_eligibility_path
      end
    else
      render :show
    end
  end

  private

  def load_eligibility
    @eligibility = current_user.basic_eligibility || current_user.build_basic_eligibility
  end

  def eligibility_params
    if params[:eligibility] # if question was not answered params[:eligibility] is nil
      params.require(:eligibility).permit(step)
    else
      {}
    end
  end

  def set_steps
    self.steps = @eligibility.questions
  end
end
