# To 'Head of Organisation' of the Successful Business categories winners

class Users::WinnersHeadOfOrganisationMailer < ApplicationMailer
  before_action :set_end_of_embargo_deadline
  before_action :set_press_summary_deadline
  before_action :set_reception_deadlines

  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate

    @urn = @form_answer.urn
    @head_email = @form_answer.head_of_business_email
    @award_year = @form_answer.award_year.year
    @award_category_title = @form_answer.award_type_full_name
    @title = @form_answer.head_of_business_title
    @last_name = @form_answer.document["head_of_business_last_name"]
    @name = "#{@title} #{@last_name}"

    @subject = "Important information about your King's Award Entry!"

    send_mail_if_not_bounces(ENV["GOV_UK_NOTIFY_API_TEMPLATE_ID"], to: @head_email, subject: subject_with_env_prefix(@subject))
  end
end
