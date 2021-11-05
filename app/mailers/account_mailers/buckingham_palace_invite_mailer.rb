# coding: utf-8
class AccountMailers::BuckinghamPalaceInviteMailer < AccountMailers::BaseMailer
  def invite(form_answer_id, notify_to_press_contact=false)
    form_answer = FormAnswer.find(form_answer_id).decorate
    invite = form_answer.palace_invite
    @token = invite.token

    if notify_to_press_contact.present?
      @email = form_answer.press_contact_details_email
      @name = form_answer.press_contact_details_full_name
    else
      @email = form_answer.head_of_business_email
      @name = form_answer.head_of_business_full_name
    end

    reception_date = form_answer.award_year.fetch_deadline("buckingham_palace_attendees_invite").try(:trigger_at)
    @reception_date = reception_date.try(:strftime, "%A #{reception_date.day.ordinalize} %B %Y")

    palace_attendees_due = form_answer.award_year.fetch_deadline("buckingham_palace_reception_attendee_information_due_by").try(:trigger_at)
    @palace_attendees_due = palace_attendees_due.try(:strftime, "%A, #{palace_attendees_due.day.ordinalize} %B %Y")

    subject = "Deadline this Wednesday to submit guest details for The Queen’s Awards for Enterprise Reception at Windsor Castle"
    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @email, subject: subject_with_env_prefix(subject)
  end
end
