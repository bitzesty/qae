class AwardEligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :load_basic_eligibility, :load_eligibilities
  before_action :check_basic_eligibility, :set_steps, :setup_wizard
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :new, :create, :update, :destroy
  ]

  def show
    if @basic_eligibility.application? && all_eligibilities_passed?
      render :result
      return
    end

    load_eligibility

    unless step
      if @basic_eligibility.nomination?
        redirect_to wizard_path(Eligibility::Promotion.questions.first)
      else
        redirect_to wizard_path(Eligibility::Trade.questions.first)
      end
      return
    end
  end

  def update
    load_eligibility
    @eligibility.current_step = step
    if @eligibility.update(eligibility_params)
      set_steps
      setup_wizard
      if step == @development_eligibility.questions.last || step == @promotion_eligibility.questions.last
        redirect_to action: :result
      elsif !@eligibility.eligible_on_step?(step)
        redirect_to_next_eligibility
      else
        redirect_to next_wizard_path
      end
    else
      render :show
    end
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
    when *Eligibility::Promotion.questions
      @eligibility = @promotion_eligibility
    end
  end

  def load_basic_eligibility
    @basic_eligibility = current_account.basic_eligibility
  end

  def set_steps
    if @basic_eligibility.application?
      self.steps = [@trade_eligibility, @innovation_eligibility, @development_eligibility].flat_map(&:questions)
    else
      self.steps = @promotion_eligibility.questions
    end
  end

  def redirect_to_next_eligibility
    case @eligibility
    when Eligibility::Trade
      redirect_to wizard_path(Eligibility::Innovation.questions.first)
    when Eligibility::Innovation
      redirect_to wizard_path(Eligibility::Development.questions.first)
    when Eligibility::Development, Eligibility::Promotion
      redirect_to action: :result
    end
  end
end
