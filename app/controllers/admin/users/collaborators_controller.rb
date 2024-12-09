class Admin::Users::CollaboratorsController < Admin::BaseController
  expose(:user) do
    User.find(params[:user_id])
  end

  expose(:collaborator) do
    User.find(params[:collaborator_id])
  end

  expose(:search_users) do
    AdminActions::SearchCollaboratorCandidates.new(existing_collaborators: user.account.users, params: search_params)
  end

  expose(:add_collaborator_interactor) do
    AdminActions::AddCollaborator.new(account: user.account, collaborator:, params: create_params)
  end

  expose(:candidates) do
    search_users.candidates
  end

  def search
    authorize user, :can_add_collaborators_to_account?
    search_users.run if search_users.valid?
  end

  def create
    authorize user, :can_add_collaborators_to_account?

    add_collaborator_interactor.run.tap do |result|
      if result.success?
        redirect_to edit_admin_user_path(user), notice: "#{collaborator.email} successfully added to Collaborators!"
      else
        redirect_to edit_admin_user_path(user), notice: "#{collaborator.email} could not be added to Collaborators: #{result.error_messages}"
      end
    end
  end

  private

  def create_params
    params.require(:user).permit(:transfer_form_answers, :new_owner_id, :role).tap do |p|
      p[:transfer_form_answers] = ActiveModel::Type::Boolean.new.cast(p[:transfer_form_answers])
    end
  end

  def search_params
    return if params[:search].blank?

    params.require(:search).permit(:query)
  end
end
