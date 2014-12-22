class ContentOnlyController < ApplicationController
  before_action :authenticate_user!, :check_basic_eligibility, :check_award_eligibility, :check_account_completion, except: [:home, :awards_for_organisations, :enterprise_promotion_awards, :how_to_apply, :timeline, :additional_information_and_contact, :terms, :apply_for_queens_award_for_enterprise]

  expose(:form_answer) {
    FormAnswer.for_user(current_user).find(params[:id])
  }

  def dashboard
    load_eligibilities
    @user_award_forms = FormAnswer.for_user(current_user).order("award_type")
  end
end
