class AddCollaborator
  attr_reader :current_user, 
              :account, 
              :params, 
              :collaborator, 
              :email, 
              :success, 
              :new_user, 
              :generated_password,
              :devise_confirmation_token

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
    
    @new_user = true
    User.new(params)
  end

  def persist!
    collaborator.account = account

    if new_user?
      collaborator.agreed_with_privacy_policy = '1'
      collaborator.password = set_generated_password
      collaborator.skip_confirmation_notification!
      collaborator.send(:generate_confirmation_token!)
      @devise_confirmation_token = @collaborator.instance_variable_get("@raw_confirmation_token")
    end

    @success = collaborator.save
  end

  def send_collaboration_email!
    Users::CollaborationMailer.delay.access_granted(
      current_user, 
      collaborator, 
      new_user,
      generated_password,
      devise_confirmation_token)
  end

  def set_generated_password
    @generated_password = SecureRandom.hex(6)
  end

  def success?
    @success
  end

  def new_user?
    @new_user
  end
end
