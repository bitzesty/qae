class Assessor::AssessorAssignmentCollectionsController < Assessor::BaseController
  def create
    @assessor_assignment_collection = AssessorAssignmentCollection.new(create_params)
    authorize @assessor_assignment_collection, :create?

    @assessor_assignment_collection.subject = current_subject
    @assessor_assignment_collection.save
    respond_to do |format|
      format.html do
        flash[:error] = @assessor_assignment_collection.errors.full_messages.to_sentence
        redirect_back(fallback_location: root_path)
      end
    end
  end

  private

  def create_params
    params.require(:assessor_assignment_collection)
      .permit :form_answer_ids,
        :primary_assessor_id,
        :secondary_assessor_id
  end
end
