class AddCollaborator
  attr_reader :account, :params, :collaborator, :email

  def initialize(account, params)
    @account = account
    @params = params
    @email = params[:email]
    @collaborator = find_or_build_collaborator
  end

  def run
    persist!
    collaborator
  end

  def find_or_build_collaborator
    if Email.new(email).valid?
      user = User.find_by email: email
      return user if user.present? && user.account.blank?
    end
    
    User.new(params)
  end

  def persist!
    collaborator.agreed_with_privacy_policy = '1'
    collaborator.account = account
    collaborator.password = Devise.friendly_token.first(8)

    collaborator.save
  end
end
