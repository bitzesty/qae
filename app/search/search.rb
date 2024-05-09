require "ostruct"

class Search
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_reader :scope, :params, :ordered_desc, :filter_params, :query
  attr_accessor :ordered_by

  # Example usage for users
  # scope = User.scoped
  # params =
  # {
  #   sort: 'full_name.desc', # see UserSearch#sort_by_full_name for possible implementation of sort by non existing field
  #   search_filter: {
  #     role: ['regular', 'account_admin']
  #   }
  # }
  def initialize(scope)
    @scope = scope
    @params = {}
    @ordered_by = nil
    @ordered_desc = false
    @filter_params = {}
    @query = nil
  end

  def search(search_params)
    @params = search_params || {}

    if params[:sort]
      column, order = params[:sort].split(".")

      @ordered_desc = order == "desc"
      @ordered_by = column
    end

    if params[:search_filter]
      @filter_params = params[:search_filter].dup
    end

    @query = params[:query] if params[:query].present?

    self
  end

  def results
    @search_results = scope

    filter_params.each do |column, value|
      next unless value.present?

      if included_in_model_columns?(column)
        @search_results = @search_results.where(column => value)
      else
        @search_results = apply_custom_filter(@search_results, column, value)
      end
    end

    if query
      @search_results = @search_results.basic_search(query).reorder(nil)
    end

    if ordered_by
      if included_in_model_columns?(ordered_by)
        if ordered_desc
          @search_results = @search_results.order("#{ordered_by} DESC")
        else
          @search_results = @search_results.order(ordered_by)
        end
      else
        @search_results = apply_custom_sort(@search_results, params[:sort])
      end
    end

    @search_results
  end

  def filters
    @filters ||= Filter.new(filter_params)
  end

  def persisted?
    false
  end

  def query?
    query.present?
  end

  private

  def included_in_model_columns?(column)
    scope.model.column_names.include?(column.to_s)
  end

  def apply_custom_sort(scoped_results, sort_value)
    column, order = sort_value.split(".")
    desc = order == "desc"
    public_send("sort_by_#{column}", scoped_results, desc)
  end

  def apply_custom_filter(scoped_results, column, value)
    public_send("filter_by_#{column}", scoped_results, value)
  end

  class Filter < OpenStruct
    extend ActiveModel::Naming
    include ActiveModel::Conversion
  end
end
