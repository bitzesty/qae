class FormAnswerSearch < Search
  DEFAULT_SEARCH = {
    sort: 'company_or_nominee_name',
    search_filter: {
      award_type: FormAnswerDecorator::SELECT_BOX_LABELS.invert.values,
      status: FormAnswerStatusFiltering.all
    }
  }
  def sort_by_flag(scoped_results, desc = false)
    scoped_results.order(importance_flag: sort_order(!desc).to_sym).order(company_or_nominee_name: :asc)
  end

  def filter_by_status(scoped_results, value)
    scoped_results.where(state: filter_klass.internal_states(value))
  end

  def find_by_query(scoped_results, value)
    scoped_results.basic_search(value)
  end

  private

  def filter_klass
    FormAnswerStatusFiltering
  end

  def sort_order(desc = false)
    desc ? 'desc' : 'asc'
  end
end
