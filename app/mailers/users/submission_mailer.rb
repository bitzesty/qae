class Users::SubmissionMailer < ActionMailer::Base
  default from: "support@qae.co.uk"

  def success(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @account = @form_answer.account
    @account_collaborators = @account.users
    @form_owner = @form_answer.user
    @owner = @account.owner
    @urn = @form_answer.urn

    @recipients = [@owner]
    @recipients += @account_collaborators

    @subject = "[Queen's Awards for Enterprise] submission successfully created!"

    @recipients.each do |recipient|
      @recipient = recipient

      mail to: @recipient, subject: @subject
    end
  end
end
