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
    @name = "#{@title} #{@last_name}"

    deadlines = Settings.current.deadlines

    @end_of_embargo_day =
      deadlines.end_of_embargo.strftime("%A %-d %B %Y")
    @end_of_embargo_date =
      deadlines.end_of_embargo.strftime("%-d %B %Y")
    @press_book_entry_datetime =
      deadlines.buckingham_palace_confirm_press_book_notes.strftime("%d %B %Y")

    @media_deadline = deadlines.where(kind: "buckingham_palace_media_information").first
    @media_deadline = @media_deadline.try(:strftime, "%A %d %B %Y")

    @subject = "Important information about your Queen's Award Entry!"

    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @head_email, subject: @subject
  end
end
