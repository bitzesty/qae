class EligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :load_eligibility
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]

  steps *Eligibility::Basic.questions

  def show
    if @eligibility.passed?
      redirect_to award_eligibility_path
      return
    end

    unless step
      redirect_to wizard_path(:kind)
      return
    end
  end

  def update
    @eligibility.current_step = step
    if @eligibility.update(eligibility_params)
      if @eligibility.eligible?
        case step
        when :kind
          if @eligibility.kind == 'nomination'
            redirect_to root_path
          else
            redirect_to next_wizard_path
          end
        when :organization_kind
          if @eligibility.organization_kind == 'charity'
            redirect_to wizard_path(:registered)
          else
            redirect_to next_wizard_path
          end
        when :registered
          if @eligibility.registered?
            redirect_to wizard_path(:demonstrated_comercial_success)
          else
            redirect_to next_wizard_path
          end
        when :current_holder
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
end
