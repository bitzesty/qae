class AwardEligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :load_eligibilities

  steps :trade, :innovation, :development

  def show
    if all_eligibilities_passed?
      render :result
      return
    end

    unless step
      redirect_to wizard_path(:trade)
      return
    else
      case step
      when :trade
        @active_step = 1
      when :innovation
        @active_step = 2
      when :development
        @active_step = 3
      end
    end
  end

  def update
    eligibility = case step
    when :trade
      @active_step = 1
      @trade_eligibility
    when :innovation
      @active_step = 2
      @innovation_eligibility
    when :development
      @active_step = 3
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


  %w[trade innovation development].each do |award_type|
    define_method "#{award_type}_eligibility_params" do
      if params[:eligibility]
        params.require(:eligibility).permit(*"Eligibility::#{award_type.capitalize}".constantize.questions)
      else
        {}
      end
    end
  end

  def all_eligibilities_passed?
    [@trade_eligibility, @innovation_eligibility, @development_eligibility].all?(&:passed?)
  end
  helper_method :all_eligibilities_passed?
end
