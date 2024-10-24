class ContentOnlyController < ApplicationController
  before_action :authenticate_user!,
    :check_account_completion,
    :check_additional_contact_preferences,
    :check_number_of_collaborators, unless: -> { admin_signed_in? || assessor_signed_in? },
    except: [
      :home,
      :awards_for_organisations,
      :enterprise_promotion_awards,
      :how_to_apply,
      :timeline,
      :additional_information_and_contact,
      :privacy,
      :cookies,
      :accessibility_statement,
      :admin_accessibility_statement,
      :apply_for_queens_award_for_enterprise,
      :sign_up_complete,
      :submitted_nomination_successful,
    ]

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :get_current_form,
    only: [
      :award_info_innovation,
      :award_info_trade,
      :award_info_development,
      :award_info_mobility,
    ]
  # rubocop:enable Rails/LexicallyScopedActionFilter

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :get_collaborators,
    only: [
      :award_info_innovation,
      :award_info_trade,
      :award_info_development,
      :award_info_mobility,
    ]
  # rubocop:enable Rails/LexicallyScopedActionFilter

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :build_form,
    only: [
      :apply_innovation_award,
      :apply_international_trade_award,
      :apply_sustainable_development_award,
      :apply_social_mobility_award,
    ]
  # rubocop:enable Rails/LexicallyScopedActionFilter

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [:dashboard]
  before_action :clean_flash, only: [:sign_up_complete]
  before_action :check_trade_count_limit, only: :apply_international_trade_award
  before_action :check_development_count_limit, only: :apply_sustainable_development_award
  # rubocop:enable Rails/LexicallyScopedActionFilter

  expose(:form_answer) do
    current_user.form_answers.find(params[:id])
  end

  expose(:past_applications) do
    current_account.form_answers.submitted.past.group_by(&:award_year)
  end

  expose(:target_award_year) do
    if params[:award_year_id].present?
      AwardYear.find(params[:award_year_id])
    else
      AwardYear.current
    end
  end

  def dashboard
    @user_award_forms = user_award_forms

    forms = @user_award_forms.group_by(&:award_type)

    @user_award_forms_trade = forms["trade"]
    @user_award_forms_innovation = forms["innovation"]
    @user_award_forms_development = forms["development"]
    @user_award_forms_mobility = forms["mobility"]
    @user_award_forms_promotion = forms["promotion"]

    @user_award_forms_submitted = @user_award_forms.submitted

    set_unsuccessful_business_applications if Settings.unsuccessful_stage?
  end

  def award_winners_section
    @user_award_forms_submitted = user_award_forms.submitted

    render "content_only/award_winners_section/#{target_award_year.year}"
  end

  private

  def user_award_forms
    current_account.form_answers
                   .where(award_year: target_award_year)
                   .order("award_type")
  end

  def build_form
    @form_answer = current_account.form_answers.build
  end

  def get_current_form
    @form_answer = current_account.form_answers.find(params[:form_id])
    @form = @form_answer.award_form.decorate(
      answers: HashWithIndifferentAccess.new(@form_answer.document),
    )
  end

  def get_collaborators
    @collaborators = current_user.account.collaborators_without(current_user)
  end

  def clean_flash
    flash.clear
  end

  def deadline_for(kind, format = "%A, %d %B %Y")
    deadline = settings.deadlines.find_by(kind: kind)
    if deadline.present? && deadline.trigger_at.present?
      deadline.trigger_at.strftime(format)
    else
      "--/--/----"
    end
  end
  helper_method :deadline_for

  def set_unsuccessful_business_applications
    @unsuccessful_business_applications = @user_award_forms.business
                                                           .unsuccessful_applications
  end
end
