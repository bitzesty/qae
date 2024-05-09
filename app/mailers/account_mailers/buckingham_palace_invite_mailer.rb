# coding: utf-8

class AccountMailers::BuckinghamPalaceInviteMailer < AccountMailers::BaseMailer
  def invite(form_answer_id, notify_to_press_contact=false)
    form_answer = FormAnswer.find(form_answer_id).decorate
    deadlines = form_answer.award_year.settings.deadlines
    @reception_deadline = deadlines.where(kind: "buckingham_palace_reception_attendee_information_due_by").first
    @reception_deadline_time = formatted_deadline_time(@reception_deadline)
    @reception_date = deadlines.where(kind: "buckingham_palace_attendees_invite").first
    @reception_date_time = formatted_deadline_time(@reception_date)
    invite = form_answer.palace_invite
    @token = invite.token

    if notify_to_press_contact.present?
      @email = form_answer.press_contact_details_email
      @name = form_answer.press_contact_details_full_name
    else
      @email = form_answer.head_of_business_email
      @name = form_answer.head_of_business_full_name
    end

    subject = "An invitation to a Royal Reception at Windsor Castle"
    send_mail_if_not_bounces ENV["GOV_UK_NOTIFY_API_TEMPLATE_ID"], to: @email, subject: subject_with_env_prefix(subject)
  end
end
