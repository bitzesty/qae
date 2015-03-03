class ContentOnlyController < ApplicationController
  before_action :authenticate_user!, :check_account_completion, except: [:home, :awards_for_organisations, :enterprise_promotion_awards, :how_to_apply, :timeline, :additional_information_and_contact, :terms, :apply_for_queens_award_for_enterprise]

  expose(:form_answer) {
    current_user.form_answers.find(params[:id])
  }

  def dashboard
    @user_award_forms = current_user.account.form_answers.order("award_type")
  end
end
