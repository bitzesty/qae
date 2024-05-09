class FinancialSummaryPointer < FormFinancialPointer
  def initialize(form_answer, options = {})
    super
  end

  def summary_data
    @_financial_summary_data ||= begin
      with_dates_filled = fill_missing_dates
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
      d = dates.dup
      length = x.detect(&:first).values.flatten(1).size
      diff = ::Utils::Diff.calc(dates.size, length, abs: false)

      # If the diff between no. of dates & no. of elements (think of cells in the row) is bigger, 
      # we cut the dates, so we don't go over the amount of cells
      if diff 
        d.shift(diff) if diff.positive?

        # this should only happen for innovation applications, when innovation was launched prior 
        # to company started trading
        # we then calculate dates as - 1 year from the previous year
        if diff.negative?
          diff.abs.times do
            date_to_calculate_from = d.first
            if Utils::Date.valid?(date_to_calculate_from)
              date = Date.parse(date_to_calculate_from).years_ago(1).strftime("%d/%m/%Y")
              d.unshift(date) 
            else
              d.unshift(nil)
            end
          end
        end
      end

      if dates_changed
        # if dates changed, `financial_year_changed_dates` is then the first element
        # we remove it
        idx = x.index { |h| h.keys[0] == :financial_year_changed_dates }
        x.delete_at(idx) if idx
      end

      # and push `dates` as first element into the hash
      x.unshift(Hash[:dates, d])

      acc << x
    end.flatten
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
