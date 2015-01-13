class AddCollaborator
  attr_reader :current_user, :account, :params, :collaborator, :email, :success

  def initialize(current_user, account, params)
    @current_user = current_user
    @account = account
    @params = params
    @email = params[:email]
    @collaborator = find_or_build_collaborator
  end

  def run
    persist!

    if success?
      send_collaboration_email!
    end

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
    collaborator.skip_confirmation_notification!

    @success = collaborator.save
  end

  def send_collaboration_email!
    Users::CollaborationMailer.delay.access_granted(current_user, collaborator)
  end
end
