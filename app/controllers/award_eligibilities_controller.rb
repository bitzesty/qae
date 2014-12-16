class AwardEligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :load_eligibilities
  before_action :load_basic_eligibility
  before_action :check_basic_eligibility

  steps *[Eligibility::Trade, Eligibility::Innovation, Eligibility::Development].flat_map(&:questions)

  def show
    if all_eligibilities_passed?
      render :result
      return
    end

    load_eligibility

    unless step
      redirect_to wizard_path(Eligibility::Trade.questions.first)
      return
    end

    if @eligibility.class.hidden_question?(step)
      redirect_to next_wizard_path
      return
    end
  end

  def update
    load_eligibility
    @eligibility.current_step = step
    if @eligibility.update(eligibility_params)
      if step == Eligibility::Development.questions.last
        redirect_to action: :result
      else
        redirect_to next_wizard_path
      end
    else
      render :show
    end
  end

  def result
  end

  private

  def eligibility_params
    if params[:eligibility]
      params.require(:eligibility).permit(*@eligibility.class.questions)
    else
      {}
    end
  end

  def all_eligibilities_passed?
    [@trade_eligibility, @innovation_eligibility, @development_eligibility].all?(&:passed?)
  end
  helper_method :all_eligibilities_passed?

  def load_eligibility
    @eligibility = case step
    when *Eligibility::Trade.questions
      @eligibility = @trade_eligibility
    when *Eligibility::Innovation.questions
      @eligibility = @innovation_eligibility
    when *Eligibility::Development.questions
      @eligibility = @development_eligibility
    end
  end

  def load_basic_eligibility
    @basic_eligibility = current_user.basic_eligibility
  end
end
