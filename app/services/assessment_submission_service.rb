class AssessmentSubmissionService
  attr_reader :resource, :current_subject

  def initialize(assignment, current_subject)
    @resource = assignment
    @current_subject = current_subject
  end

  delegate :form_answer, to: :resource

  def perform
    resource.submission_action = true

    if resource.submitted?
      resubmit!
    else
      if submit_assessment
        populate_case_summary

        if resource.primary?
          populate_feedback
        end
      end

      if resource.moderated?
        form_answer.state_machine.assign_lead_verdict(resource.verdict_rate, current_subject)
      end

      if resource.case_summary?
        perform_state_transition!
      end
    end
  end

  def resubmit!
    # TODO: probably need further actions!
    # NEED TO CONFIRM!
    #
    if set_submitted_at_as_now!
      if resource.primary?
        populate_feedback
      end
    end
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

  def populate_feedback
    feedback = form_answer.feedback || form_answer.build_feedback

    document = {}

    AppraisalForm.const_get("#{form_answer.award_type.upcase}_#{form_answer.award_year.year}").each do |attr, _|
      if attr == :verdict
        document["overall_summary"] = resource.document["verdict_desc"]

        next
      end

      if resource.document["#{attr}_rate"] == "positive"
        document["#{attr}_strength"] = resource.document["#{attr}_desc"]
        document["#{attr}_weakness"] = ""
      else
        document["#{attr}_weakness"] = resource.document["#{attr}_desc"]
        document["#{attr}_strength"] = ""
      end
    end

    feedback.document = document
    feedback.save
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
