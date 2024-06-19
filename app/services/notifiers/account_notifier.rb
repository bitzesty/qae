class Notifiers::AccountNotifier
  attr_reader :account, :form_answer

  def form_owner
    @form_owner ||= form_answer.user
  end

  def account_owner
    @account_owner ||= account.owner
  end

  def account_collaborators
    @account_collaborators ||= account.users
  end

  def recipients
    @recipients = [account_owner]
    @recipients += [form_owner] if form_answer
    @recipients += account_collaborators

    @recipients.uniq!
  end
end
