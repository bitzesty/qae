class CollaboratorRemovalService
  def initialize(collaborator, account)
    @collaborator = collaborator
    @account = account
  end

  def reassign_form_answers
    User.transaction do
      @collaborator.account_id = Account.create(owner: @collaborator).id
      @collaborator.role = "account_admin"
      @collaborator.save!
      @collaborator.form_answers.update_all(user_id: @account.owner_id)
    end
  end
end
