require 'qae_2014_forms'

class ContentOnlyController < ApplicationController
  before_filter :authenticate_user!, except: [:home]

  def home
  end

  def innovation
    @form = QAE2014Forms.innovation
    render template: 'qae_form/show'
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
