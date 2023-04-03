# coding: utf-8
class AccountMailers::BusinessAppsWinnersMailer < AccountMailers::BaseMailer
  before_action :set_end_of_embargo_deadline
  before_action :set_media_deadline
  before_action :set_press_summary_deadline

  def notify(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    collaborator = User.find(collaborator_id)

    @name = "#{@user.title} #{@user.last_name}"

    subject = "Important information about your King's Award"
    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: collaborator.email, subject: subject_with_env_prefix(subject)
  end
end
