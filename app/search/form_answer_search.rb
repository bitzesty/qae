class FormAnswerSearch < Search
  def sort_by_company_name(scoped_results, desc = false)
    scoped_results.joins(:user).order("users.company_name #{desc ? 'DESC' : 'ASC'}")
  end
end