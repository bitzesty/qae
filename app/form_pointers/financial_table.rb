module FinancialTable
  def get_audit_data(key)
    res = audit_data.detect do |d|
      d.keys.first.to_s == key.to_s
    end

    res.present? ? res[key.to_sym] : financial_empty_values
  end

  def financial_table_headers
    if financial_year_changed_dates_value.present?
      financial_table_changed_dates_headers
    elsif (financial_date_day.to_i > 0 && financial_date_month.to_i > 0)
      financial_table_pointer_headers
    else
      financial_table_default_headers
    end
  end

  def financial_table_changed_dates_headers
    res = financial_data(
      :financial_year_changed_dates,
      get_audit_data(:financial_year_changed_dates)
    )

    if res.any? { |el| el.present? }
      correct_date_headers(res)
    else
      [''] * res.size
    end
  end

  def correct_date_headers(res)
    corrected_result = []
    last_year = res.last.split("/")[2].to_i

    res.each_with_index do |entry, index|
      # Trade form has locked year cells and
      # also they are no saving in db (as we do not save disabled fields via autosave)
      # so data can be: "13/02/"
      corrected_result << if entry.size == 6 && (index + 1) != res.size
        year = last_year - (res.size - (index + 1))
        entry += year.to_s
        entry
      else
        entry
      end
    end

    corrected_result
  end

  def financial_table_pointer_headers
    res = []

    (financial_years_number.to_i - 1).times do |i|
      el = financial_date_pointer_value
      el[2] = el[2] - (i + 1)
      res.unshift(el.join("/"))
    end

    res << financial_date_pointer_value.join("/")
    res
  end

  def financial_table_default_headers
    res = []

    financial_years_number.to_i.times do |i|
      res << "Financial year #{i + 1}"
    end

    res
  end

  def financial_empty_values
    res = []

    financial_years_number.to_i.times do |i|
      res << {}
    end

    res
  end

  def financial_year_changed_dates_value
    financial_pointer.filled_answers["financial_year_date_changed"].to_s == "yes"
  end

  def financial_date_selector
    step_questions.detect do |q|
      q.delegate_obj.try(:financial_date_selector).present?
    end
  end

  def financial_date_selector_value
    filled_answers[financial_date_selector.key.to_s]
  end

  def financial_date_pointer
    step_questions.detect do |q|
      q.delegate_obj.try(:financial_date_pointer).present?
    end
  end

  def financial_date_day
    financial_pointer.filled_answers["financial_year_date_day"]
  end

  def financial_date_month
    financial_pointer.filled_answers["financial_year_date_month"]
  end

  def financial_date_pointer_value
    FinancialYearPointer.new(
      question: financial_date_pointer,
      financial_pointer: financial_pointer
    ).latest_year_label
  end

  def financial_years_number
    if financial_date_selector_value.present?
      financial_date_selector.ops_values[financial_date_selector_value]
    elsif financial_pointer.period_length.present? && financial_pointer.period_length > 0
      financial_pointer.period_length
    else
      # If not selected yet, render first option as default
      financial_date_selector.ops_values.values.first
    end
  end
end
