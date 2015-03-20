class AssessmentSubmissionService
  attr_reader :resource

  def initialize(assignment)
    @resource = assignment
  end

  def perform
    return if resource.submitted?

    submit_assessment

    populate_primary_case_summary
    populate_lead_case_summary
  end

  delegate :as_json, to: :resource

  private

  def submit_assessment
    resource.update(submitted_at: DateTime.now)
  end

  def populate_primary_case_summary
    return unless resource.moderated?
    rec = record(3)
    rec.document = resource.document
    rec.save
  end

  def populate_lead_case_summary
    return unless resource.primary_case_summary?
    rec = record(4)
    rec.document = resource.document
    rec.save
  end

  def record(position)
    AssessorAssignment.where(
      form_answer_id: resource.form_answer_id, position: position
    ).first_or_create
  end
end
