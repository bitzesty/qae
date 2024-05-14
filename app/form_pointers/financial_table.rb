module FinancialTable
  def get_audit_data(key)
    res = audit_data.detect do |d|
      d.keys.first.to_s == key.to_s
    end

    res.present? ? res[key.to_sym] : financial_empty_values
  end

  def financial_table_headers
    if financial_year_changed_dates?
      financial_table_changed_dates_headers
    elsif financial_date_day.to_i > 0 && financial_date_month.to_i > 0
      financial_table_pointer_headers
    else
      financial_table_default_headers
    end
  end

  def financial_table_changed_dates_headers
    res = financial_data(:financial_year_changed_dates, get_audit_data(:financial_year_changed_dates))

    # Get the no. of fields ~> `res.size`
    # Check if there is difference between current amount (`res.size`) and calculated amount (`innovation_years_number`)
    # If there should be more, push the empty string to the front
    # If there should be less, take it from the front
    #
    if form_answer.innovation?
      diff = ::Utils::Diff.calc(innovation_years_number, res.size, abs: false) || 0

      res.shift(diff.abs) if diff.negative?

      if diff.positive?
        diff.times do
          date_to_calculate_from = res.first
          if Utils::Date.valid?(date_to_calculate_from)
            date = Date.parse(date_to_calculate_from).years_ago(1).strftime("%d/%m/%Y")
            res.unshift(date)
          else
            res.unshift(nil)
          end
        end
      end
    end

    if res.any?(&:present?)
      correct_date_headers(res)
    else
      [""] * res.size
    end
  end

  def correct_date_headers(res)
    # Trade form has locked year cells and
    # also they are no saving in db (as we do not save disabled fields via autosave)
    # so data can be: "13/02/"
    # Probably better just to check if date is valid and only then push as correct one
    # Should help to avoid all that weirdness when trying to display invalid dates
    #
    res.each_with_object([]) do |entry, memo|
      memo << if ::Utils::Date.valid?(entry)
        Date.parse(entry).strftime("%d/%m/%Y")
      else
        ""
      end
    end
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

  def financial_year_changed_dates?
    financial_pointer.filled_answers["financial_year_date_changed"].to_s == "yes"
  end

  def financial_date_selector
    step_questions.detect do |q|
      q.delegate_obj.try(:financial_date_selector).present?
    end
  end

  def financial_date_selector_value
    if one_option_question_or_development?
      "3"
    elsif form_answer.innovation?
      innovation_years_number
    else
      filled_answers[financial_date_selector.key.to_s]
    end
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
      financial_pointer: financial_pointer,
    ).latest_year_label
  end

  def financial_years_number
    @financial_years_number ||=
      if financial_date_selector_value.present?
        if one_option_question_or_development?
          "3"
        elsif form_answer.innovation?
          innovation_years_number
        else
          financial_date_selector.ops_values[financial_date_selector_value]
        end
      elsif financial_pointer.period_length.present? && financial_pointer.period_length > 0
        financial_pointer.period_length
      else
        # If not selected yet, render last option as default
        financial_date_selector.ops_values.values.last
      end
  end

  def one_option_question_or_development?
    one_option_question? || form_answer.development?
  end

  def one_option_question?
    question.is_a?(QaeFormBuilder::OneOptionByYearsLabelQuestionDecorator) ||
      question.is_a?(QaeFormBuilder::OneOptionByYearsQuestionDecorator) ||
      question.is_a?(QaeFormBuilder::OneOptionByYearsLabelQuestion) ||
      question.is_a?(QaeFormBuilder::OneOptionByYearsQuestion) ||
      (question.delegate_obj.is_a?(QaeFormBuilder::FinancialSummaryQuestion) && question.one_option?)
  end

  def innovation_years_number
    doc = form_answer.document
    form = question.form
    years = 5

    # rubocop:disable Lint/EnsureReturn
    begin
      result = question.by_year_conditions.find do |c|
        date = []
        q = form[c.question_key]

        q.required_sub_fields.each do |sub|
          date << doc.dig("#{q.key}_#{sub.keys[0]}")
        end

        date = Date.parse(date.join("/"))

        c.question_value.call(date)
      end

      years = result.years if result.present?
    rescue
      nil
    ensure
      return years.to_s
    end
    # rubocop:enable Lint/EnsureReturn
  end
end
