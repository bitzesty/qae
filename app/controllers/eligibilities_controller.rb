class EligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :load_eligibility

  steps *Eligibility.questions

  def show
    if @eligibility.passed?
      redirect_to correspondent_details_account_path
      return
    end

    unless step
      redirect_to wizard_path(:kind)
      return
    end
  end

  def update
    @eligibility.current_step = step
    if @eligibility.update_attributes(eligibility_params)
      if @eligibility.eligible?
        case step
        when :kind
          if @eligibility.kind == 'nomination'
            redirect_to root_path
          else
            redirect_to next_wizard_path
          end
        when :organization_kind
          if @eligibility.kind == 'charity'
            redirect_to wizard_path(:based_in_uk)
          else
            redirect_to next_wizard_path
          end
        when :demonstrated_comercial_success
          redirect_to success_eligibility_path
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
    @eligibility = current_user.eligibility || current_user.build_eligibility
  end

  def eligibility_params
    if params[:eligibility] # if question was not answered params[:eligibility] is nil
      params.require(:eligibility).permit(step)
    else
      {}
    end
  end
end
