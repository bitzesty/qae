module AssessorAssignmentContext
  def update
    assessment = AssessorAssignmentService.new(params, current_subject)
    authorize assessment.resource, :update?

    respond_to do |format|
      if assessment.save
        log_event unless has_paper_trail?
        format.json { render json: { errors: [] } }
      else
        format.json { render status: :unprocessable_entity,
                             json: { errors: assessment.resource.errors } }
        Appsignal.send_error(Exception.new("Failed to save `AssessorAssignment##{assessor_assignment.id}. \n #{assessment.resource.errors} \n #{params}"))
      end

      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  private

  def assessor_assignment
    AssessorAssignment.find(params[:id])
  end

  def form_answer
    assessor_assignment.form_answer
  end

  def has_paper_trail?
    assessor_assignment.versions.last.object_changes.keys.include? "assessor_id"
  end

  def action_type
    assessor_assignment.position == "case_summary" ? "case_summary_update" : "#{assessor_assignment.position}_appraisal_update"
  end

end
