class Users::SupporterMailer < ApplicationMailer
  def success(supporter_id, user_id)
    @user = User.find(user_id).decorate
    @supporter = Supporter.find(supporter_id).decorate
    @form_answer = @supporter.form_answer.decorate
    @subject = "[Queen's Awards for Enterprise] Support Letter Request"
    @nominee_name = @form_answer.nominee_full_name

    mail to: @supporter.email, subject: @subject
  end
end
