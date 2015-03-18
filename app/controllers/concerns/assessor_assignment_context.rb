module AssessorAssignmentContext
  def update
    assessment = AssessorAssignmentService.new(params, current_subject)
    authorize assessment.resource, :update?

    assessment.save

    respond_to do |format|
      format.json do
        if assessment.save
          render json: { errors: [] }
        else
          render status: :unprocessable_entity,
                 json: { errors: assessment.resource.errors }
        end
      end
      format.html { redirect_to(:back) }
    end
  end
end
