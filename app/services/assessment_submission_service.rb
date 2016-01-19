class AssessmentSubmissionService
  SEVEN_KEYS_STRENGTHS = [:environment_protection,
                          :benefiting_the_wilder_community,
                          :sustainable_resource,
                          :economic_sustainability,
                          :supporting_employees,
                          :internal_leadership,
                          :industry_sector]

  attr_reader :resource, :current_subject

  def initialize(assignment, current_subject)
    @resource = assignment
    @current_subject = current_subject
  end

  delegate :form_answer, to: :resource

  def perform
    if resource.submitted?
      resubmit! if resource.case_summary?
    else
      if submit_assessment
        populate_case_summary
      end

      if resource.moderated?
        form_answer.state_machine.assign_lead_verdict(resource.verdict_rate, current_subject)
      end

      if resource.case_summary?
        perform_state_transition!
        populate_feedback!
      end
    end
  end

  def resubmit!
    # TODO: probably need further actions!
    # NEED TO CONFIRM!
    #
    set_submitted_at_as_now!
  end

  delegate :as_json, to: :resource

  private

  def submit_assessment
    set_submitted_at_as_now!
  end

  def set_submitted_at_as_now!
    resource.update(
      submitted_at: DateTime.now,
      locked_at: DateTime.now
    )
  end

  def populate_case_summary
    if resource.moderated?
      case_summary = record(AssessorAssignment.positions[:case_summary])
      primary_assessment = record(AssessorAssignment.positions[:primary])
      moderated_assessment = record(AssessorAssignment.positions[:moderated])

      document = primary_assessment.document.merge(
        "verdict_rate" => moderated_assessment.document["verdict_rate"]
      )

      case_summary.document = document
      case_summary.save
    end
  end

  def populate_feedback!
    return unless form_answer.development?
    return if form_answer.feedback

    feedback = form_answer.build_feedback
    feedback.authorable = current_subject
    feedback.document = {}

    AppraisalForm::DEVELOPMENT.keys.each do |attr|
      if SEVEN_KEYS_STRENGTHS.include?(attr)
        feedback.document["#{attr}_desc"] = resource.document["#{attr}_desc"]
        feedback.document["#{attr}_rate"] = resource.document["#{attr}_rate"]
      end
    end

    feedback.save!
  end

  def primary_and_lead_is_the_same_person?
    # possibly some logic can be reviewed
    primary = form_answer.assessors.primary
    Assessor.leads_for(form_answer.award_type).include?(primary)
  end

  def record(position)
    AssessorAssignment.where(
      form_answer_id: form_answer.id, position: position
    ).first_or_create
  end

  private

  def perform_state_transition!
    state_machine = form_answer.state_machine
    state_machine.assign_lead_verdict(resource.verdict_rate, current_subject)
  end
end
