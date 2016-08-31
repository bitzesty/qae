class FormAnswerSearch < Search
  attr_reader :subject

  DEFAULT_SEARCH = {
    sort: 'company_or_nominee_name',
    search_filter: {
      award_type: FormAnswer::AWARD_TYPE_FULL_NAMES.invert.values,
      status: FormAnswerStatus::AdminFilter.all
    }
  }

  def initialize(scope, subject)
    @subject = subject
    super(scope)
  end

  # admin comments with flags + global flag per application
  def sort_by_flag(scoped_results, desc = false)
    section = (@subject.is_a?(Admin) ? "admin" : "critical")
    section = Comment.sections[section]

    q = "form_answers.*,
      (COUNT(comments.id)) AS flags_count"
    scoped_results.select(q)
      .joins("LEFT OUTER JOIN comments on comments.commentable_id=form_answers.id")
      .group("form_answers.id")
      .where("(comments.section =? AND comments.commentable_type=? AND flagged =?)
        OR comments.section IS NULL", section, "FormAnswer", true)
      .order("flags_count #{sort_order(desc)}")
  end

  def sort_by_sic_status
    # TODO
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
      when "missing_audit_certificate"
        out = out.joins(
          "LEFT OUTER JOIN audit_certificates ON audit_certificates.form_answer_id=form_answers.id"
        ).where("audit_certificates.id IS NULL")
      when "audit_certificate_not_reviewed"
        out = out.joins(
          "JOIN audit_certificates auditcerts ON auditcerts.form_answer_id=form_answers.id"
        ).where("auditcerts.reviewed_at IS NULL")
      when "missing_feedback"
        out = out.joins(
          "LEFT OUTER JOIN feedbacks on feedbacks.form_answer_id=form_answers.id"
        ).where("feedbacks.submitted = false OR feedbacks.id IS NULL")
      when "missing_press_summary"
        out = out.joins(
          "LEFT OUTER JOIN press_summaries on press_summaries.form_answer_id = form_answers.id"
        ).where("press_summaries.id IS NULL OR press_summaries.approved = false")
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
    desc ? 'desc' : 'asc'
  end
end
