class Search
  attr_reader :scope, :params, :ordered_by, :ordered_desc, :filter

  # Example usage for users
  # scope = User.scoped
  # params =
  # {
  #   sort: 'last_login.desc', # see UserSearch#last_login for possible implementation of sort by non existing field
  #   filter: {
  #     role: ['regular', 'account_admin']
  #   }
  # }
  def initialize(scope)
    @scope        = scope
    @params       = {}
    @ordered_by   = nil
    @ordered_desc = false
    @filter       = {}
  end

  def search(search_params)
    @params = search_params || {}

    if params[:sort]

      @ordered_desc = params[:sort].split('.').last == 'desc'
      @ordered_by   = params[:sort].split('.').first
    end

    if params[:filter]
      @filter = params[:filter]
    end

    self
  end

  def results
    @search_results = scope

    if ordered_by
      if ordered_desc
        @search_results = @search_results.order("#{ordered_by} DESC")
      else
        @search_results = @search_results.order(ordered_by)
      end
    end

    filter.each do |column, value|
      @search_results = @search_results.where(column: value)
    end

    @search_results
  end

  def method_missing(method, *args, &block)
    if filter[method.to_s]
      filter[method.to_s]
    else
      super
    end
  end
end
