class UserSearch < Search
  DEFAULT_SEARCH = {
    sort: 'full_name',
    search_filter: {
      role: User.role.values
    }
  }

  def sort_by_full_name(scoped_results, desc = false)
    if desc
      scoped_results.order("first_name DESC, last_name DESC")
    else
      scoped_results.order("first_name ASC, last_name ASC")
    end
  end
end
