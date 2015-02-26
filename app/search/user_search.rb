class UserSearch < Search
  DEFAULT_SEARCH = {
    sort: "full_name",
    search_filter: {
      role: User.role.values
    }
  }

  include FullNameSort

  def find_by_query(scoped_results, value)
    scoped_results.basic_search(value)
  end
end
