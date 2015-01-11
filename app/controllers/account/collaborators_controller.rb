class Account::CollaboratorsController < Account::BaseController

  before_action :require_to_be_account_admin!
  before_action :require_to_be_not_current_user!, only: [:edit, :update, :destroy]

  expose(:account) do
    current_user.account
  end
  expose(:collaborators) do
    account.collaborators_without(current_user)
  end
  expose(:collaborator) do
    collaborators.find(params[:id])
  end

  def index
  end

  def new
    self.collaborator = User.new
  end

  def create
    self.collaborator = User.new(create_params)
    collaborator.agreed_with_privacy_policy = '1'
    collaborator.account = account

    collaborator.save
  end

  def edit
  end

  def update
    collaborator.update(update_params)
  end

  def destroy
    self.collaborator.account = nil
    self.collaborator.save
  end

  private

  def create_params
    params.require(:collaborator).permit(
      :email, 
      :role
    )
  end

  def update_params
    params.require(:collaborator).permit(
      :role
    )
  end

  def require_to_be_account_admin!
    unless current_user.account_admin?
      redirect_to root_path,
                  notice: "Access denied!"
    end
  end

  def require_to_be_not_current_user!
    if current_user.id == user.id
      redirect_to root_path,
                  notice: "You can't update / remove your self in collaborators!"
    end
  end
end
