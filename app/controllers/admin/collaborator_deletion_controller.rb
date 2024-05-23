class Admin::CollaboratorDeletionController < Admin::BaseController
  def destroy
    form_id = params[:form_id].presence
    collaborator = User.find(params[:id])
    account = collaborator.account

    authorize :collaborator, :destroy?

    CollaboratorRemovalService.new(collaborator, account).reassign_form_answers

    redirect_to edit_admin_user_path(account.owner), notice: "#{collaborator.email} successfully removed from Collaborators!"
  end
end
