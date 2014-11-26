class ContentOnlyController < ApplicationController
  before_filter :authenticate_user!,
    :only => [
      :dashboard,
      :eligibility_1,
      :eligibility_2,
      :eligibility_3,
      :eligibility_4,
      :eligibility_5,
      :eligibility_6,
      :eligibility_success,
      :eligibility_failure,
      :eligibility_check_1,
      :eligibility_check_2,
      :eligibility_check_3,
      :apply_innovation_award,
      :innovation_award_eligible,
      :innovation_award_form_1,
      :innovation_award_form_2,
      :innovation_award_form_3,
      :innovation_award_form_4,
      :innovation_award_form_5,
      :innovation_award_confirm,
      :account
    ]

  def home
  end

  def eligibility_check_1
    @active_step = 1
  end

  def eligibility_check_2
    @active_step = 2
  end

  def eligibility_check_3
    @active_step = 3
  end

  def innovation_award_eligible
    @active_step = 1
  end

  def innovation_award_form_1
    @active_step = 2
  end

  def innovation_award_form_2
    @active_step = 3
  end

  def innovation_award_form_3
    @active_step = 4
  end

  def innovation_award_form_4
    @active_step = 5
  end

  def innovation_award_form_5
    @active_step = 6
  end
end
