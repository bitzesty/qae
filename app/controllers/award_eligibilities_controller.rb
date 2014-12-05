class AwardEligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!

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
end
