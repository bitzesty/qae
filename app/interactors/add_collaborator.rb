class AddCollaborator
  attr_reader :current_user, 
              :account, 
              :params, 
              :collaborator, 
              :email, 
              :success, 
              :new_user, 
              :generated_password,
              :devise_confirmation_token,
              :errors

  def initialize(current_user, account, params)
    @current_user = current_user
    @account = account
    @params = params
    @email = params[:email]
    @collaborator = find_or_build_collaborator
  end

  def run
    if valid? && collaborator.valid?
      persist! 

      if success?
        send_collaboration_email!
      end
    end

    self
  end

  def find_or_build_collaborator
    if Email.new(email).valid?
      user = User.find_by email: email

      if user.present?
        if user.account_id == account.id
          @errors = Array.wrap "This user already added to collaborators!"
        end

        user.role = params[:role]
        return user 
      end
    end
    
    @new_user = true
    user = User.new(params)
    user.agreed_with_privacy_policy = '1'
    user.password = set_generated_password

    user
  end

  def persist!
    collaborator.account = account
    
    if collaborator.new_record?
      collaborator.skip_confirmation_notification!
      collaborator.send(:generate_confirmation_token!)
      @devise_confirmation_token = collaborator.instance_variable_get("@raw_confirmation_token")
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

  def valid?
    @errors.blank?
  end
end
