module FormAnswerStatus::FilteringHelper
  def internal_states(filtering_values)
    filtering_values = Array(filtering_values)

    filtering_values.flat_map do |val|
      options[val.to_sym][:states] if supported_filter_attrs.include?(val.to_s)
    end.compact
  end

  def collection
    options.map do |k, v|
      [v[:label], k]
    end
  end

  def sub_collection
    sub_options.map do |k, v|
      [v[:label], k]
    end
  end

  def supported_filter_attrs
    options.keys.map(&:to_s)
  end

  def all
    collection.map { |s| s.last.to_s } + sub_collection.map { |s| s.last.to_s }
  end
end
