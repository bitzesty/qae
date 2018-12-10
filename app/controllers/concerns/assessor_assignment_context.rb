module AssessorAssignmentContext
  def update
    assessment = AssessorAssignmentService.new(params, current_subject)
    authorize assessment.resource, :update?

    respond_to do |format|
      if assessment.save
        format.json { render json: { errors: [] } }
      else
        format.json { render status: :unprocessable_entity,
                             json: { errors: assessment.resource.errors } }
      end

      format.html { redirect_back(fallback_location: root_path) }
    end
  end
end
