class AdminSearch < Search
  DEFAULT_SEARCH = {
    sort: "full_name",
  }

  include FullNameSort
end
