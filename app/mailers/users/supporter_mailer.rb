class Users::SupporterMailer < ActionMailer::Base
  default from: "support@qae.co.uk"

  def success(supporter_id, user_id)
    @user = User.find(user_id).decorate
    @supporter = Supporter.find(supporter_id).decorate
    @form_answer = @supporter.form_answer.decorate
    @subject = "[Queen's Awards for Enterprise] Support Letter Request"

    mail to: @supporter.email, subject: @subject
  end
end
