# coding: utf-8
class AccountMailers::BusinessAppsWinnersMailer < AccountMailers::BaseMailer
  def notify(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    collaborator = User.find(collaborator_id)

    @name = "#{@user.title} #{@user.last_name}"

    deadlines = Settings.current.deadlines
    @end_of_embargo = deadlines.where(kind: "buckingham_palace_attendees_details").first
    @end_of_embargo_time = formatted_deadline_time(@end_of_embargo)

    @media_deadline = deadlines.where(kind: "buckingham_palace_media_information").first

    @book_notes_deadline = deadlines.where(kind: "buckingham_palace_confirm_press_book_notes").first
    @book_notes_deadline_time = formatted_deadline_time(@book_notes_deadline)

    subject = "Important information about your Kings's Award"
    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: collaborator.email, subject: subject_with_env_prefix(subject)
  end
end
