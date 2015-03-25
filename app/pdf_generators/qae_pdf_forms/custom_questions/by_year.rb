module QaePdfForms::CustomQuestions::ByYear
  YEAR_LABELS = %w(day month year)
  YEAR_LABELS_TABLE_HEADERS = [
    "Financial year", "Day", "Month", "Year"
  ]
  IN_PROGRESS = "in progress..."

  def render_years_labels_table
    rows = financial_year_changed_dates_entries
    rows.map do |e|
      e[1] = to_month(e[1])
    end

    rows.push(latest_year_label)
    active_fields.length.times do |i|
      rows[i].unshift(i + 1)
    end

    rows.each do |row|
      form_pdf.default_bottom_margin

      financial_year_text = "#{YEAR_LABELS_TABLE_HEADERS[0]} #{row[0]}"
      if row == rows.last
        financial_year_text += " (Current)"
      end

      financial_date_text = ""
      (1...row.count).each do |col|
        financial_date_text += "#{row[col]} "
      end

      form_pdf.text "#{financial_year_text}: <font name='Times-Roman'><color rgb='999999'>#{financial_date_text}</color></font>",
                    inline_format: true
    end
  end

  def render_years_table
    rows = active_fields.map do |field|
      entry = year_entry(field)
      entry.present? ? entry : IN_PROGRESS
    end

    render_single_row_list(financial_years_decorated_headers, rows)
  end

  def financial_years_decorated_headers
    headers = financial_year_changed_dates_entries.map do |entry|
      decorated_label(entry)
    end

    headers.push(decorated_label(latest_year_label(false)))
  end

  def financial_year_changed_dates_entries
    if financial_year_changed_dates_question.present?
      financial_year_changed_dates_question.active_fields[0..-2].map do |field|
        YEAR_LABELS.map do |year_label|
          fetch_year_label(field, year_label, :financial_year_changed_dates, false)
        end
      end
    else
      []
    end
  end

  def financial_year_changed_dates_question
    step.filtered_questions.detect do |q|
      q.key == :financial_year_changed_dates
    end
  end

  def active_fields
    question.decorate(answers: form_pdf.filled_answers).active_fields
  end

  def fetch_year_label(field, year_label, q_key = nil, with_month_check = true)
    entry = year_entry(field, year_label, q_key)

    if entry.present?
      if with_month_check && year_label == "month"
        to_month(entry)
      else
        entry
      end
    else
      "-"
    end
  end

  def year_entry(field, year_label = nil, q_key = nil)
    entry = form_pdf.filled_answers.detect do |k, _v|
      k == "#{q_key || key}_#{field}#{year_label}"
    end

    entry[1] if entry.present?
  end

  def latest_year_label(with_month_check = true)
    month = if with_month_check
              to_month(form_pdf.filled_answers["financial_year_date_month"])
            else
              form_pdf.filled_answers["financial_year_date_month"]
    end

    [
      "0" + form_pdf.filled_answers["financial_year_date_day"],
      month,
      Date.today.year
    ]
  end

  def decorated_label(label)
    "Year ending in " + label.join("/")
  end
end
