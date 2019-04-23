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

    if primary_and_secondary_assessments_submitted?
      check_if_there_are_any_discrepancies_between_primary_and_secondary_appraisals!
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

    appraisal_form_settings.each do |attr, _|
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

  def perform_state_transition!
    state_machine = form_answer.state_machine
    state_machine.assign_lead_verdict(resource.verdict_rate, current_subject)
  end

  def check_if_there_are_any_discrepancies_between_primary_and_secondary_appraisals!
    discrepancies = []

    rag_type_keys = AppraisalForm.meths_for_award_type(form_answer)
                                 .select do |a|
      a.to_s.ends_with?("_rate")
    end

    rag_type_keys.map do |rag_key|
      primary_grade = primary_assessment.document[rag_key.to_s] || ''
      secondary_grade = secondary_assessment.document[rag_key.to_s] || ''

      if primary_grade != secondary_grade
        q_main_key = rag_key.to_s
                            .gsub('_rate', '')
                            .to_sym

        appraisal_title = appraisal_form_settings[q_main_key][:label][0..-2]

        discrepancies << [
          rag_key, 
          appraisal_title,
          primary_grade, 
          secondary_grade
        ]
      end
    end

    if discrepancies.present?
      primary_assessor = primary_assessment.assessor
      secondary_assessor = secondary_assessment.assessor

      res = {
        discrepancies: discrepancies,
        primary_assessor_name: primary_assessor.full_name,
        primary_assessor_email: primary_assessor.email,
        primary_assessor_submitted_at: primary_assessment.submitted_at,
        secondary_assessor_name: secondary_assessment.full_name,
        secondary_assessor_email: secondary_assessment.email,
        secondary_assessor_submitted_at: secondary_assessment.submitted_at
      }

      form_answer.update_column(
        :discrepancies_between_primary_and_secondary_appraisals, res
      )
    end
  end

  def primary_and_secondary_assessments_submitted?
    primary_assessment.submitted? && 
    secondary_assessment.submitted?
  end

  def primary_assessment
    @primary_assessment ||= record(AssessorAssignment.positions[:primary])
  end

  def secondary_assessment
    @secondary_assessment ||= record(AssessorAssignment.positions[:secondary])
  end

  def appraisal_form_settings
    AppraisalForm.const_get("#{form_answer.award_type.upcase}_#{form_answer.award_year.year}")
  end
end
