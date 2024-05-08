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

      if resource.moderated? || resource.case_summary?
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

      if resource.moderated?
        perform_state_transition!
      end
    end
  end

  delegate :as_json, :errors, to: :resource

  private

  def submit_assessment
    set_submitted_at_as_now!
  end

  def set_submitted_at_as_now!
    resource.update(
      submitted_at: DateTime.now,
      locked_at: DateTime.now,
    )
  end

  def populate_case_summary
    if resource.moderated?
      case_summary = record(AssessorAssignment.positions[:case_summary])
      moderated_assessment = record(AssessorAssignment.positions[:moderated])

      document = primary_assessment.document.merge(
        "verdict_rate" => moderated_assessment.document["verdict_rate"],
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
      form_answer_id: form_answer.id, position: position,
    ).first_or_create
  end

  def perform_state_transition!
    state_machine = form_answer.state_machine
    state_machine.assign_lead_verdict(resource.verdict_rate, current_subject)
  end

  def check_if_there_are_any_discrepancies_between_primary_and_secondary_appraisals!
    discrepancies = []

    rate_type_keys = AppraisalForm.meths_for_award_type(form_answer)
                                 .select do |a|
      a.to_s.ends_with?("_rate")
    end

    rate_type_keys.map do |rate_key|
      primary_grade = primary_assessment.document[rate_key.to_s] || ""
      secondary_grade = secondary_assessment.document[rate_key.to_s] || ""

      if primary_grade != secondary_grade
        q_main_key = rate_key.to_s
                            .gsub("_rate", "")
                            .to_sym

        appraisal_title = appraisal_form_settings[q_main_key][:label][0..-2]

        labels = question_answer_labels(q_main_key)
        primary_grade_label = get_answer_label(labels, primary_grade)
        secondary_grade_label = get_answer_label(labels, secondary_grade)

        discrepancies << [
          rate_key,
          appraisal_title,
          primary_grade_label,
          secondary_grade_label
        ]
      end
    end

    if discrepancies.present?
      primary_assessor = primary_assessment.assessor
      secondary_assessor = secondary_assessment.assessor

      res = {
        discrepancies: discrepancies,
        primary_assessor_name: primary_assessor&.full_name,
        primary_assessor_email: primary_assessor&.email,
        primary_assessor_submitted_at: format_date(primary_assessment.submitted_at),
        secondary_assessor_name: secondary_assessor&.full_name,
        secondary_assessor_email: secondary_assessor&.email,
        secondary_assessor_submitted_at: format_date(secondary_assessment.submitted_at),
      }

      form_answer.update_column(
        :discrepancies_between_primary_and_secondary_appraisals, res,
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

  def question_answer_labels(key)
    q_type = if key.to_s == "corporate_social_responsibility"
      "CSR_RAG"
    else
      get_question_type(key)
    end

    AppraisalForm.const_get("#{q_type.upcase}_OPTIONS_#{form_answer.award_year.year}")
  end

  def get_question_type(key)
    appraisal_form_settings[key][:type]
  end

  def get_answer_label(labels, grade)
    labels.detect do |el|
      el[1] == grade
    end[0]
  end

  def format_date(val)
    val.strftime("%e %b %Y at %-l:%M%P")
  end
end
