class ContentOnlyController < ApplicationController
  before_action :authenticate_user!, :check_basic_eligibility, :check_award_eligibility, :check_account_completion, except: [:home, :awards_for_organisations, :enterprise_promotion_awards, :how_to_apply, :timeline, :additional_information_and_contact, :terms, :apply_for_queens_award_for_enterprise]

  expose(:form_answer) {
    FormAnswer.for_user(current_user).find(params[:id])
  }

  def home
    @is_landing_page = true
  end

  def awards_for_organisations
    @is_landing_page = true
  end

  def enterprise_promotion_awards
    @is_landing_page = true
  end

  def how_to_apply
    @is_landing_page = true
  end

  def timeline
    @is_landing_page = true
  end

  def additional_information_and_contact
    @is_landing_page = true
  end

  def terms
    @is_landing_page = true
  end

  def apply_for_queens_award_for_enterprise
    @is_landing_page = true
  end

  def dashboard
    load_eligibilities
    @user_award_forms = FormAnswer.for_user(current_user).order("award_type")
  end

end
