class AddCollaborator
  attr_reader :account, :collaborator, :success

  def initialize(account, collaborator)
    @account = account
    @collaborator = collaborator
  end

  def run
    persist!
    collaborator
  end

  def persist!
    collaborator.agreed_with_privacy_policy = '1'
    collaborator.account = account
    collaborator.password = Devise.friendly_token.first(8)

    collaborator.save
  end
end
