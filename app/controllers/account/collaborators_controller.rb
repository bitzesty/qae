class Account::CollaboratorsController < Account::BaseController

  before_action :require_to_be_not_current_user!, only: [:destroy]
  before_action :restrict_access_if_admin_in_read_only_mode!

  before_action :set_form_answer

  expose(:account) do
    current_user.account
  end
  expose(:collaborators) do
    account.collaborators_without(current_user)
  end
  expose(:collaborator) do
    collaborators.find(params[:id])
  end
  expose(:add_collaborator_interactor) do
    AddCollaborator.new(
        current_user,
        account,
        {})
  end

  def index
    @active_step = 4
  end

  def new
    @active_step = 4

    self.collaborator = User.new
  end

  def create
    self.add_collaborator_interactor = AddCollaborator.new(
      current_user,
      account,
      create_params).run
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

  def destroy
    collaborator.account_id = nil
    collaborator.role = nil
    collaborator.save(validate: false)

    if params.has_key? :form_id
      redirect_to account_collaborators_path(form_id: params[:form_id]),
                  notice: "#{collaborator.email} successfully removed from Collaborators!"
    else
      redirect_to account_collaborators_path,
                  notice: "#{collaborator.email} successfully removed from Collaborators!"
    end
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
      :phone_number,
      :email,
      :role,
      :form_id
    )
  end

  def require_to_be_not_current_user!
    render head :forbidden if current_user.id == collaborator.id
  end
end
