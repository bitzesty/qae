class Submission::SuccessNotifier
  attr_reader :form_answer, :recipients

  def initialize(form_answer)
    @form_answer = form_answer

    account = form_answer.account
    account_collaborators = account.users
    account_owner = account.owner
    form_owner = form_answer.user

    @recipients = [form_owner, account_owner]
    @recipients += account_collaborators
    @recipients.uniq!
  end

  def run
    recipients.each do |recipient|
      Users::SubmissionMailer.delay.success(recipient.id, form_answer.id)
    end
  end
end
