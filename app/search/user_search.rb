class UserSearch < Search
  DEFAULT_SEARCH = {
    sort: "full_name",
    search_filter: {
      role: User.role.values,
    },
  }

  include FullNameSort
end
