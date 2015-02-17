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
      column, order = params[:sort].split('.')

      if included_in_model_columns?(column)
        @ordered_desc = order == 'desc'
        @ordered_by   = column
      else
        raise 'not implemented'
        apply_custom_sort(params[:sort])
      end
    end

    if params[:filter]
      @filter = params[:filter]
    end

    self
  end

  def results
    @search_results = scope

    if ordered_by
      if included_in_model_columns?(ordered_by)
        if ordered_desc
          @search_results = @search_results.order("#{ordered_by} DESC")
        else
          @search_results = @search_results.order(ordered_by)
        end
      else
        raise 'not implemented'
        @search_results = apply_custom_sort(@search_results, params[:sort])
      end
    end

    filter.each do |column, value|
      if included_in_model_columns?(column)
        @search_results = @search_results.where(column: value)
      else
        raise 'not implemented'
        @search_results = apply_custom_filter(@search_results, column, value)
      end
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

  private

  def included_in_model_columns?(column)
    scope.model.column_names.include?(column)
  end
end
