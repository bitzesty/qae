class ContentOnlyController < ApplicationController
  before_action :authenticate_user!, :check_account_completion, except: [:home, :awards_for_organisations, :enterprise_promotion_awards, :how_to_apply, :timeline, :additional_information_and_contact, :terms, :apply_for_queens_award_for_enterprise]

  expose(:form_answer) {
    current_user.form_answers.find(params[:id])
  }

  def dashboard
    load_eligibilities
    @user_award_forms = current_user.account.form_answers.order("award_type")
  end

  def award_info_development
    @form_answer = current_account.form_answers.find(params[:form_id])
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
  end

  def award_info_innovation
    @form_answer = current_account.form_answers.find(params[:form_id])
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
  end

  def award_info_trade
    @form_answer = current_account.form_answers.find(params[:form_id])
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
  end

  def award_info_promotion
    @form_answer = current_account.form_answers.find(params[:form_id])
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
  end
end
