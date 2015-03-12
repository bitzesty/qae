class ContentOnlyController < ApplicationController
  before_action :authenticate_user!, :check_account_completion, except: [:home, :awards_for_organisations, :enterprise_promotion_awards, :how_to_apply, :timeline, :additional_information_and_contact, :terms, :apply_for_queens_award_for_enterprise]

  before_action :get_current_form, only: [
    :award_info_innovation,
    :award_info_trade,
    :award_info_development,
    :award_info_promotion
  ]

  before_action :landing_page, only: [
    :home,
    :awards_for_organisations,
    :enterprise_promotion_awards,
    :how_to_apply,
    :timeline,
    :additional_information_and_contact,
    :apply_for_queens_award_for_enterprise
  ]

  expose(:form_answer) {
    current_user.form_answers.find(params[:id])
  }

  def dashboard
    @user_award_forms = current_user.account.form_answers.order("award_type")
    @user_award_forms_trade = @user_award_forms.where("award_type"=>"trade")
    @user_award_forms_innovation = @user_award_forms.where("award_type"=>"innovation")
    @user_award_forms_development = @user_award_forms.where("award_type"=>"development")
    @user_award_forms_promotion = @user_award_forms.where("award_type"=>"promotion")
  end

  def get_current_form
    @form_answer = current_account.form_answers.find(params[:form_id])
    @form = @form_answer.award_form.decorate(
      answers: HashWithIndifferentAccess.new(@form_answer.document)
    )
  end

  def landing_page
    @is_landing_page = true
  end

  def landing_page?
    if defined? @is_landing_page
      return true
    end
  end
end
