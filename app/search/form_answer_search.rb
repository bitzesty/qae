class FormAnswerSearch < Search
  attr_reader :subject

  DEFAULT_SEARCH = {
    sort: 'company_or_nominee_name',
    search_filter: {
      award_type: FormAnswerDecorator::SELECT_BOX_LABELS.invert.values,
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
        out = out.where("sic_code IS NULL")
      when "assessors_not_assigned"
        out = out.where(primary_assessor_id: nil, secondary_assessor_id: nil)
      when "missing_audit_certificate"
        out = out.joins(
          "LEFT OUTER JOIN audit_certificates ON audit_certificates.form_answer_id=form_answers.id"
        ).where("audit_certificates.id IS NULL")
      when "missing_feedback"
        out = out.joins(
          "LEFT OUTER JOIN feedbacks on feedbacks.form_answer_id=form_answers.id"
        ).where("feedbacks.approved = false OR feedbacks.id IS NULL")
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
      when "missing_corp_responsibility"
        q = "form_answers.document->>'corp_responsibility_form' = 'declare_now'"
        out = out.where(q)
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

  def sort_order(desc = false)
    desc ? 'desc' : 'asc'
  end
end
