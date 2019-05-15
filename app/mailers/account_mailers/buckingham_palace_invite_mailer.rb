class AccountMailers::BuckinghamPalaceInviteMailer < AccountMailers::BaseMailer
  def invite(form_answer_id, notify_to_press_contact=false)
    form_answer = FormAnswer.find(form_answer_id).decorate
    invite = form_answer.palace_invite
    @token = invite.token

    if notify_to_press_contact.present?
      @email = form_answer.press_contact_details_email
      @name = form_answer.press_contact_details_full_name
    else
      @email = form_answer.head_email
      @name = form_answer.head_of_business_full_name
    end

    reception_date = AwardYear.buckingham_palace_reception_date
    @reception_date = reception_date.try(:strftime, "%A #{reception_date.day.ordinalize} %B %Y")

    palace_attendees_due = AwardYear.buckingham_palace_reception_attendee_information_due_by
    @palace_attendees_due = palace_attendees_due.try(:strftime, "%A, #{palace_attendees_due.day.ordinalize} %B %Y")

    subject = "An invitation to HM The Queen's Reception at Buckingham Palace"
    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @email, subject: subject
  end
end
