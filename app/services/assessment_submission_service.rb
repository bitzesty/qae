class AssessmentSubmissionService
  attr_reader :resource, :current_subject

  def initialize(assignment, current_subject)
    @resource = assignment
    @current_subject = current_subject
  end

  def perform
    return if resource.submitted?
    if submit_assessment
      populate_primary_case_summary
      populate_lead_case_summary
    end
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
    if (current_subject.lead?(resource.form_answer) &&
       current_subject.primary?(resource.form_answer)) ||
       resource.primary_case_summary?
      notify
      rec = record(4)
      rec.document = resource.document
      rec.save
    end
  end

  def record(position)
    AssessorAssignment.where(
      form_answer_id: resource.form_answer_id, position: position
    ).first_or_create
  end

  def notify
    if current_subject.primary?(resource.form_answer) &&
       !current_subject.lead?(resource.form_answer)
      Assessor.leads_for(resource.form_answer.award_type).each do |assessor|
        mailer = Assessors::PrimaryCaseSummaryMailer
        mailer.notify(assessor.id, resource.form_answer.id).deliver_later!
      end
    end
  end
end
