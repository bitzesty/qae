class Assessor::AssessmentSubmissionsController < Assessor::BaseController
  def create
    @assignment = AssessorAssignment.find(params[:assessment_id])

    authorize @assignment, :submit?
    @assignment.submit_assessment

    respond_to do |format|
      format.json do
        if @assignment.errors.blank?
          render json: {}
        else
          render for_js
        end
      end

      format.html { redirect_to assessor_form_answer_path(@assignment.form_answer) }
    end
  end

  private

  def for_js
    {
      json: {
        error: "All assessment sections should be fulfilled"
      },
      status: :unprocessable_entity
    }
  end
end
