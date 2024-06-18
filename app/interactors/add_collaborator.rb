class AddCollaborator
  attr_reader :current_user,
    :account,
    :params,
    :collaborator,
    :email,
    :success,
    :new_user,
    :errors

  def initialize(current_user, account, params)
    @current_user = current_user
    @account = account
    @readonly = false
    @params = params
    @email = params[:email]
    @collaborator = find_or_build_collaborator
  end

  def run
    if valid? && collaborator.valid?
      collaborator.account = account
      @success = collaborator.save
    end

    self
  end

  def find_or_build_collaborator
    if Email.new(email).valid?
      user = User.find_by email: email

      if user.present?
        if user.account_id == account.id
          @errors = ["This user already added to collaborators!"]
        elsif user.account.present?
          @errors = ["User already associated with another account!"]
          @readonly = true
        end

        user.role = params[:role]
        return user
      end
    end

    @new_user = true
    user = User.new(params)
    user.agreed_with_privacy_policy = "1"
    user.skip_password_validation = true
    user
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

  def readonly?
    !!@readonly
  end
end
