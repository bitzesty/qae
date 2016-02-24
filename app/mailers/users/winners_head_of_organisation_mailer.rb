# To 'Head of Organisation' of the Successful Business categories winners

class Users::WinnersHeadOfOrganisationMailer < ApplicationMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate

    @urn = @form_answer.urn
    @head_email = @form_answer.head_email
    @award_year = @form_answer.award_year.year
    @award_category_title = @form_answer.award_type_full_name
    @title = @form_answer.head_of_bussines_title
    @last_name = @form_answer.document["head_of_business_last_name"]

    @media_deadline = Settings.current.deadlines.where(kind: "buckingham_palace_media_information").first
    @media_deadline = @media_deadline.try :strftime, "%H.%M on %A %d %B %Y"

    @subject = "[Queen's Awards for Enterprise] Important information about your Queen's Award Entry!"

    mail to: @head_email, subject: @subject
  end
end
