class FormAnswerSearch < Search
  def sort_by_company_name(scoped_results, desc = false)
    scoped_results.joins(:user).order("users.company_name #{desc ? 'DESC' : 'ASC'}")
  end

  def filter_by_status(scoped_results, value)
    return scoped_results if value == filter_klass::SELECT_ALL.to_s
    scoped_results.where(state: filter_klass.internal_states(value))
  end

  FormAnswerStatusFiltering::SUB_OPTIONS.each do |k,v|
    define_method "filter_by_#{k}" do |scoped_results, value|
      # TODO: no states support - custom logic necessary
      scoped_results
    end
  end

  def search(search_params)
    s_param = search_params[:search_filter]
    if s_param.present? && s_param[:status] == filter_klass::SELECT_ALL.to_s
      # filter out any sub options params if select_all chosen
      filters_to_override = filter_klass::SUB_OPTIONS.keys.map(&:to_s)

      s_param.delete_if{|k, _| filters_to_override.include?(k)}

      search_params[:search_filter] = s_param
    end
    super search_params
  end

  private

  def filter_klass
    FormAnswerStatusFiltering
  end
end