class FormAnswerSearch < Search
  attr_reader :subject

  DEFAULT_SEARCH = {
    sort: "company_or_nominee_name",
    search_filter: {
      award_type: FormAnswer::AWARD_TYPE_FULL_NAMES.invert.values,
      status: FormAnswerStatus::AdminFilter.all,
    },
  }

  def initialize(scope, subject)
    @subject = subject
    super(scope)

    @scope = @scope.select(advanced_select)
               .joins("LEFT OUTER JOIN form_answers AS other_applications ON other_applications.account_id = form_answers.account_id AND other_applications.id != form_answers.id AND other_applications.state in #{post_submission_states_for_sql}")
  end

  # admin comments with flags + global flag per application
  def sort_by_flag(scoped_results, desc = false)
    section = (@subject.is_a?(Admin) ? "admin" : "critical")
    section = Comment.sections[section]

    q = "form_answers.*,
      (COUNT(other_applications) > 0) AS applied_before,
      (COUNT(flagged_comments.id)) AS flags_count"
    scoped_results.select(q)
      .joins("LEFT OUTER JOIN comments  AS flagged_comments on (flagged_comments.commentable_id=form_answers.id) AND ((flagged_comments.section = '#{section}' AND flagged_comments.commentable_type = 'FormAnswer' AND flagged_comments.flagged = true) OR flagged_comments.section IS NULL)")
      .group("form_answers.id")
      .order("flags_count #{sort_order(desc)}")
  end

  def sort_by_applied_before(scoped_results, desc = false)
    scoped_results.order("applied_before #{sort_order(desc)}")
  end

  def sort_by_sic_code(scoped_results, desc = false)
    scoped_results.order(Arel.sql("(form_answers.document #>> '{sic_code}') #{sort_order(desc)}"))
  end

  def sort_by_primary_assessor_name(scoped_results, desc = false)
    scoped_results
      .joins("LEFT OUTER JOIN assessors on form_answers.primary_assessor_id = assessors.id")
      .select("form_answers.*, CONCAT(assessors.first_name, assessors.last_name) as assessor_full_name")
      .order("assessor_full_name #{sort_order(desc)}").group("assessors.first_name, assessors.last_name")
  end

  def sort_by_secondary_assessor_name(scoped_results, desc = false)
    scoped_results
      .joins("LEFT OUTER JOIN assessors on form_answers.secondary_assessor_id = assessors.id")
      .select("form_answers.*, CONCAT(assessors.first_name, assessors.last_name) as assessor_full_name")
      .order("assessor_full_name #{sort_order(desc)}").group("assessors.first_name, assessors.last_name")
  end

  def sort_by_audit_updated_at(scoped_results, desc = false)
    scoped_results
      .joins("LEFT OUTER JOIN (SELECT audit_logs.auditable_id, audit_logs.auditable_type, MAX(audit_logs.created_at) latest_audit_date FROM audit_logs
       WHERE audit_logs.action_type != 'download_form_answer'
       GROUP BY audit_logs.auditable_id, audit_logs.auditable_type) max_audit_dates ON max_audit_dates.auditable_id = form_answers.id AND max_audit_dates.auditable_type = 'FormAnswer'")
      .order(Arel.sql("COALESCE(max_audit_dates.latest_audit_date, TO_DATE('20101031', 'YYYYMMDD')) #{sort_order(desc)}"))
      .group("max_audit_dates.latest_audit_date")
  end

  def filter_by_status(scoped_results, value)
    scoped_results.where(state: filter_klass.internal_states(value))
  end

  def filter_by_sub_status(scoped_results, value)
    out = scoped_results
    value.each do |v|
      case v
      when "missing_sic_code"
        out = out.where("(form_answers.document #>> '{sic_code}') IS NULL")
      when "assessors_not_assigned"
        out = out.where(primary_assessor_id: nil, secondary_assessor_id: nil)
      when "primary_assessment_submitted"
        out = primary_assessment_submitted(out)
      when "secondary_assessment_submitted"
        out = secondary_assessment_submitted(out)
      when "missing_additional_finances"
        out = out.joins(
          "LEFT OUTER JOIN audit_certificates ON audit_certificates.form_answer_id=form_answers.id"
        ).joins(
          "LEFT OUTER JOIN shortlisted_documents_wrappers ON shortlisted_documents_wrappers.form_answer_id = form_answers.id"
        ).joins(
          "LEFT OUTER JOIN award_years awd_yrs ON awd_yrs.id = form_answers.award_year_id"
        ).where("(awd_yrs.year >= 2023 AND (
                   (form_answers.award_type IN ('trade', 'innovation') AND audit_certificates.id IS NULL)
                   OR (form_answers.award_type IN ('development', 'mobility') AND form_answers.document #>> '{product_estimated_figures}' = 'yes' AND shortlisted_documents_wrappers.submitted_at IS NULL)
                 )
                 OR (awd_yrs.year < 2023 AND audit_certificates.id IS NULL))")
      when "additional_finances_not_reviewed"
       out = out.joins(
          "LEFT OUTER JOIN audit_certificates ON audit_certificates.form_answer_id=form_answers.id"
        ).joins(
          "LEFT OUTER JOIN shortlisted_documents_wrappers ON shortlisted_documents_wrappers.form_answer_id = form_answers.id"
        ).joins(
          "LEFT OUTER JOIN award_years awd_yrs ON awd_yrs.id = form_answers.award_year_id"
        ).where("(awd_yrs.year >= 2023 AND (
                   (form_answers.award_type IN ('trade', 'innovation') AND audit_certificates.reviewed_at IS NULL)
                   OR (form_answers.award_type IN ('development', 'mobility') AND form_answers.document #>> '{product_estimated_figures}' = 'yes' AND shortlisted_documents_wrappers.reviewed_at IS NULL)
                 )
                 OR (awd_yrs.year < 2023 AND audit_certificates.reviewed_at IS NULL))")
      when "missing_feedback"
        out = out.joins(
          "LEFT OUTER JOIN feedbacks on feedbacks.form_answer_id=form_answers.id"
        ).where("feedbacks.submitted = false OR feedbacks.id IS NULL")
      when "missing_press_summary"
        out = out.joins(
          "LEFT OUTER JOIN press_summaries on press_summaries.form_answer_id = form_answers.id"
        ).where("press_summaries.id IS NULL OR press_summaries.submitted = false")
      when "missing_rsvp_details"
        out = out.joins(
          "LEFT OUTER JOIN palace_invites on palace_invites.form_answer_id = form_answers.id"
        ).joins(
          "LEFT OUTER JOIN palace_attendees ON palace_attendees.palace_invite_id = palace_invites.id"
        ).where("palace_invites.id IS NULL OR palace_attendees.id IS NULL")
      when "primary_and_secondary_assessments_submitted"
        out = primary_assessment_submitted(out)
        out = secondary_assessment_submitted(out)
      when "primary_assessment_not_submitted"
        out = out.joins(
          "JOIN assessor_assignments primary_assignments ON primary_assignments.form_answer_id=form_answers.id"
        ).where("primary_assignments.position = ? AND primary_assignments.submitted_at IS NULL", AssessorAssignment.positions[:primary])
      when "secondary_assessment_not_submitted"
        out = out.joins(
          "JOIN assessor_assignments secondary_assignments ON secondary_assignments.form_answer_id=form_answers.id"
        ).where("secondary_assignments.position = ? AND secondary_assignments.submitted_at IS NULL", AssessorAssignment.positions[:secondary])
      when "recommendation_disperancy"
        # both assessments should be submitted
        out = primary_assessment_submitted(out)
        out = secondary_assessment_submitted(out)
        out = out.where("(secondary_assignments.document -> 'verdict_rate') != (primary_assignments.document -> 'verdict_rate')")
      end
    end

    out
  end

  private

  def post_submission_states_for_sql
    quoted_states = FormAnswerStateMachine::POST_SUBMISSION_STATES.map { |s| "'#{s}'"}

    "(#{quoted_states.join(', ')})"
  end

  def advanced_select
    "form_answers.*, (COUNT(other_applications) > 0) AS applied_before"
  end

  def filter_klass
    if subject.is_a?(Admin)
      FormAnswerStatus::AdminFilter
    else
      FormAnswerStatus::AssessorFilter
    end
  end

  def primary_assessment_submitted(scope)
    scope.joins(
      "JOIN assessor_assignments primary_assignments ON primary_assignments.form_answer_id=form_answers.id"
    ).where("primary_assignments.position = ? AND primary_assignments.submitted_at IS NOT NULL", AssessorAssignment.positions[:primary])
  end

  def secondary_assessment_submitted(scope)
    scope.joins(
      "JOIN assessor_assignments secondary_assignments ON secondary_assignments.form_answer_id=form_answers.id"
    ).where("secondary_assignments.position = ? AND secondary_assignments.submitted_at IS NOT NULL", AssessorAssignment.positions[:secondary])
  end

  def sort_order(desc = false)
    desc ? "desc" : "asc"
  end
end
