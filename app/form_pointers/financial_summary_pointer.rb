class FinancialSummaryPointer < FormFinancialPointer
  def initialize(form_answer, options = {})
    super
  end

  def summary_data
    @_financial_summary_data ||= begin
      with_dates_filled = fill_missing_dates
      puts with_dates_filled
      fill_missing_fields(with_dates_filled)
    end
  end

  def financial_years
    values = summary_data.detect { |d| d[:dates] }
    values && values[:dates]
  end

  private

  def fill_missing_fields(input)
    minmax = data_minmax(data)

    cloned = input.deep_dup

    result = cloned.each_with_object([]) do |h, memo|
      key, values = h.keys[0], h.values[0]

      if values.length == minmax[:max]
        memo << h
        next
      end

      cloned = case values[0]
               when Hash
                 values[0].transform_values { |_v| nil }
               when Array
                 []
               else
                 nil
               end

      diff = ::Utils::Diff.calc(minmax[:min], minmax[:max])
      diff.times { values.unshift(cloned) }

      memo << Hash[key, values]
    end

    result
  end

  def fill_missing_dates
    input = data.group_by do |x|
              partitioned_hash.values.each_with_object(Hash[]).with_index do |(x, acc), idx|
                x.each { |y| acc[y] = idx }
              end.fetch(x.keys[0], 0)
            end

    dates, dates_changed = fetch_financial_year_dates

    input.values.each_with_object([]) do |x, acc|
      max = data_minmax(x).dig(:max)
      diff = ::Utils::Diff.calc(dates.size, max, abs: false)
      d = dates.dup

      if dates_changed
        d.shift(diff) if diff && diff.positive?

        idx = x.index { |h| h.keys[0] == :financial_year_changed_dates }
        x.delete_at(idx) if idx
      else
        d.shift(diff)
      end

      x.unshift(Hash[:dates, d])

      acc << x
    end.flatten
  end

  def partitioned_hash
    target_financial_questions.group_by(&:section)
                              .transform_values { |values| values.map(&:key) }
  end

  private

  def fetch_financial_year_dates
    @_financial_year_dates ||= begin
      dates, changed = if data_values(:financial_year_changed_dates).present?
                         [financial_year_changed_dates, true]
                       else
                         [financial_year_dates, false]
                       end

      [dates, changed]
    end
  end
end
