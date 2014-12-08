class AwardEligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :load_eligibilities

  steps :trade, :innovation, :development

  def show
    if [@trade_eligibility, @innovation_eligibility, @development_eligibility].all?(&:passed?)
      render :result
      return
    end

    unless step
      redirect_to wizard_path(:trade)
      return
    end
  end

  def update
    eligibility = case step
    when :trade
      @trade_eligibility
    when :innovation
      @innovation_eligibility
    when :development
      @development_eligibility
    end

    if eligibility.update(send("#{step}_eligibility_params"))
      if step == :development
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

  def load_eligibilities
    @trade_eligibility = current_user.trade_eligibility || current_user.build_trade_eligibility
    @innovation_eligibility = current_user.innovation_eligibility || current_user.build_innovation_eligibility
    @development_eligibility = current_user.development_eligibility || current_user.build_development_eligibility
  end

  def trade_eligibility_params
    params.require(:eligibility).permit(*Eligibility::Trade.questions)
  end

  def innovation_eligibility_params
    params.require(:eligibility).permit(*Eligibility::Innovation.questions)
  end

  def development_eligibility_params
    params.require(:eligibility).permit(*Eligibility::Development.questions)
  end
end
