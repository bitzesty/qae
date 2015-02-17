class UserSearch < Search
  def sort_by_full_name(scoped_results, desc = false)
    if desc
      scoped_results.order("first_name DESC, last_name DESC")
    else
      scoped_results.order("first_name ASC, last_name ASC")
    end
  end
end
