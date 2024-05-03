class Users::SupporterMailer < ApplicationMailer
  def success(supporter_id, user_id)
    @user = User.find(user_id).decorate
    @supporter = Supporter.find(supporter_id).decorate
    @form_answer = @supporter.form_answer.decorate
    @subject = "[King's Awards for Enterprise] Support Letter Request"
    @nominee_name = @form_answer.nominee_full_name
    @nominator_name = @form_answer.nominator_full_name
    @nominator_email = @form_answer.nominator_email

    send_mail_if_not_bounces ENV.fetch("GOV_UK_NOTIFY_API_TEMPLATE_ID", nil), to: @supporter.email,
                                                                              subject: subject_with_env_prefix(@subject)
  end
end
