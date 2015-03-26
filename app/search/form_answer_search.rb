class FormAnswerSearch < Search
  attr_reader :subject

  DEFAULT_SEARCH = {
    sort: 'company_or_nominee_name',
    search_filter: {
      award_type: FormAnswerDecorator::SELECT_BOX_LABELS.invert.values,
      status: FormAnswerStatusFiltering.all
    }
  }

  def initialize(scope, subject)
    @subject = subject
    super(scope)
  end

  def sort_by_flag(scoped_results, desc = false)
    section = (@subject.is_a?(Admin) ? "admin" : "critical")
    section = Comment.sections[section]

    scoped_results.select("form_answers.*, COUNT(comments.id) AS flags_count").
      joins("LEFT OUTER JOIN comments on comments.commentable_id=form_answers.id").
      group("form_answers.id").
      where("(comments.section =? AND comments.commentable_type=? AND flagged =?)
        OR comments.section IS NULL", section, "FormAnswer", true)
      .order("flags_count #{sort_order(desc)}")
  end

  def filter_by_status(scoped_results, value)
    scoped_results.where(state: filter_klass.internal_states(value))
  end

  private

  def filter_klass
    if subject.is_a?(Admin)
      FormAnswerStatusFiltering
    else
      FormAnswerStatus::AssessorFilter
    end
  end

  def sort_order(desc = false)
    desc ? 'desc' : 'asc'
  end
end
