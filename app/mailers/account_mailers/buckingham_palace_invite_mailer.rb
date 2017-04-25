class AccountMailers::BuckinghamPalaceInviteMailer < AccountMailers::BaseMailer
  def invite(form_answer_id)
    form_answer = FormAnswer.find(form_answer_id).decorate
    email = form_answer.head_email
    invite = form_answer.palace_invite
    @token = invite.token

    @name = form_answer.head_of_business_full_name

    reception_date = AwardYear.buckingham_palace_reception_date
    @reception_date = reception_date.try(:strftime, "%A #{reception_date.day.ordinalize} %B %Y")

    palace_attendees_due = AwardYear.buckingham_palace_reception_attendee_information_due_by
    @palace_attendees_due = palace_attendees_due.try(:strftime, "%A #{palace_attendees_due.day.ordinalize} %B %Y")


    subject = "An invitation to HM The Queen's Reception at Buckingham Palace"
    mail to: email, subject: subject
  end
end
