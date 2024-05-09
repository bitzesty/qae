class Admin::FormAnswers::CollaboratorsController < Admin::BaseController
  expose(:form_answer) do
    FormAnswer.find(params[:form_answer_id])
  end

  expose(:user) do
    User.find(params[:user_id])
  end

  expose(:search_users) do
    AdminActions::SearchCollaboratorCandidates.new(
      form_answer,
      search_params,
    )
  end

  expose(:add_collaborator_interactor) do
    AdminActions::AddCollaborator.new(
      form_answer,
      user,
    )
  end

  expose(:candidates) do
    search_users.candidates
  end

  def search
    authorize form_answer, :can_add_collaborators_to_application?

    if search_users.valid?
      search_users.run
    end
  end

  def create
    authorize form_answer, :can_add_collaborators_to_application?

    add_collaborator_interactor.run
  end

  private

  def search_params
    if params[:search].present?
      params.require(:search).permit(
        :query,
      )
    end
  end
end
