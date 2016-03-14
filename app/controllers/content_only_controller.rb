class ContentOnlyController < ApplicationController
  before_action :authenticate_user!,
                :check_account_completion,
                except: [
                  :home,
                  :awards_for_organisations,
                  :enterprise_promotion_awards,
                  :how_to_apply,
                  :timeline,
                  :additional_information_and_contact,
                  :privacy,
                  :cookies,
                  :apply_for_queens_award_for_enterprise,
                  :sign_up_complete,
                  :submitted_nomination_successful
                ]

  before_action :get_current_form,
                only: [
                  :award_info_innovation,
                  :award_info_trade,
                  :award_info_development,
                  :award_info_promotion
                ]

  before_action :get_collaborators,
                only: [
                  :award_info_innovation,
                  :award_info_trade,
                  :award_info_development,
                  :award_info_promotion
                ]

  before_action :restrict_access_if_admin_in_read_only_mode!,
                only: [:dashboard]

  before_action :clean_flash, only: [:sign_up_complete]

  expose(:form_answer) {
    current_user.form_answers.find(params[:id])
  }

  def dashboard
    @user_award_forms = current_account.form_answers
                                       .where(award_year: AwardYear.current)
                                       .order("award_type")

    forms = @user_award_forms.group_by(&:award_type)

    @user_award_forms_trade = forms["trade"]
    @user_award_forms_innovation = forms["innovation"]
    @user_award_forms_development = forms["development"]
    @user_award_forms_promotion = forms["promotion"]

    @user_award_forms_submitted = @user_award_forms.where(submitted: true)
  end

  def award_winners_section
    @user_award_forms_submitted = current_account.form_answers
                                                 .where(submitted: true)
                                                 .order("award_type")
    render "content_only/award_winners_section/#{AwardYear.current.year}"
  end

  private

  def get_current_form
    @form_answer = current_account.form_answers.find(params[:form_id])
    @form = @form_answer.award_form.decorate(
      answers: HashWithIndifferentAccess.new(@form_answer.document)
    )
  end

  def get_collaborators
    @collaborators = current_user.account.collaborators_without(current_user)
  end

  def clean_flash
    flash.clear
  end

  def deadline_for(kind, format = "%A %d %B %Y")
    deadline = settings.deadlines.find_by(kind: kind)
    if deadline.present? && deadline.trigger_at.present?
      deadline.trigger_at.strftime(format)
    else
      "--/--/----"
    end
  end
  helper_method :deadline_for
end
