class Account::CollaboratorsController < Account::BaseController

  before_action :require_to_be_not_current_user_and_not_account_owner!, only: [:destroy]
  before_action :set_form_answer

  expose(:account) do
    current_user.account
  end
  expose(:account_owner) do
    account.owner
  end
  expose(:collaborators) do
    account.collaborators_without(current_user)
           .not_including(account_owner)
  end
  expose(:collaborator) do
    collaborators.find(params[:id])
  end
  expose(:add_collaborator_interactor) do
    AddCollaborator.new(
      current_user,
      account,
      {},)
  end

  def index
    @active_step = 4

    if current_user.account_admin?
      current_account.update_column(:collaborators_checked_at, Time.zone.now)
    end
  end

  def new
    @active_step = 4

    self.collaborator = User.new
  end

  def create
    self.add_collaborator_interactor = AddCollaborator.new(
      current_user,
      account,
      create_params,).run
    self.collaborator = add_collaborator_interactor.collaborator

    if add_collaborator_interactor.success?
      if params.has_key? :form_id
        redirect_to account_collaborators_path(form_id: params[:form_id]),
          notice: "#{collaborator.email} successfully added to Collaborators!"
      else
        redirect_to account_collaborators_path,
          notice: "#{collaborator.email} successfully added to Collaborators!"
      end
    else
      render :new
    end
  end

  def update
    if collaborator.update(update_params)
      redirect_to account_collaborators_path,
        notice: "The collaborator #{collaborator.email} details were successfully updated."
    else
      render :edit
    end
  end

  def confirm_deletion
  end

  def destroy
    form_id = params[:form_id].presence

    collaborator.account_id = Account.create(owner: collaborator).id
    collaborator.role = "account_admin"
    collaborator.save!
    collaborator.form_answers
                .update_all(user_id: account.owner_id)

    redirect_to account_collaborators_path(form_id: form_id),
      notice: "#{collaborator.email} successfully removed from Collaborators!"
  end

  def set_form_answer
    if params.has_key? :form_id
      @form_answer = current_account.form_answers.find(params[:form_id])
    end
  end

  private

  def create_params
    params.require(:collaborator).permit(
      :title,
      :first_name,
      :last_name,
      :job_title,
      :phone_number,
      :email,
      :role,
      :form_id,
    )
  end

  def update_params
    params.require(:collaborator).permit(
      :title,
      :first_name,
      :last_name,
      :job_title,
      :phone_number,
      :role,
    )
  end

  def require_to_be_not_current_user_and_not_account_owner!
    if current_user.id == collaborator.id ||
       account_owner.id == collaborator.id

      render head :forbidden
    end
  end
end
