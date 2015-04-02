module QaePdfForms::CustomQuestions::ByYear
  YEAR_LABELS = %w(day month year)
  YEAR_LABELS_TABLE_HEADERS = [
    "Financial year", "Day", "Month", "Year"
  ]
  IN_PROGRESS = "in progress..."
  FINANCIAL_YEAR_PREFIX = "Financial year"
  YEAR_ENDING_IN_PREFIX = "Year ending in"
  AS_AT_DATE_PREFIX = "As at"
  AS_AT_DATE_PREFIX_QUESTION_KEYS = [
    :total_net_assets
  ]

  def render_years_labels_table
    rows = financial_year_changed_dates_entries
    # TODO: rows = financial_table_changed_dates_headers.map { |a| a.split("/") }

    rows.map do |e|
      e[1] = to_month(e[1])
    end

    # TODO: remove rows.push(latest_year_label)
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

      financial_date_compiled_text = "#{financial_year_text}: "
      financial_date_compiled_text += "<font name='Times-Roman'><color rgb='999999'>"
      financial_date_compiled_text += financial_date_text
      financial_date_compiled_text += "</color></font>"

      form_pdf.text financial_date_compiled_text,
                    inline_format: true
    end
  end

  def render_years_table
    Rails.logger.info "[active_fields] #{active_fields}"

    rows = active_fields.map do |field|
      entry = year_entry(field)
      entry.present? ? entry : IN_PROGRESS
    end

    Rails.logger.info "[rows] #{rows.inspect}"

    Rails.logger.info "[year_headers] #{year_headers.inspect}"

    render_single_row_list(year_headers, rows)
  end

  def year_headers
    if financial_year_changed_dates_value
      financial_dates_changed_year_headers
    else
      financial_dates_not_changed_year_headers
    end
  end

  def financial_dates_changed_year_headers
    res = []
    size = financial_table_headers.size

    financial_table_headers.each_with_index do |item, placement|
      header_item = "#{FINANCIAL_YEAR_PREFIX} #{placement + 1}"
      header_item += " (Current)" if (size == (placement + 1))

      res << header_item
    end

    res
  end

  def financial_dates_not_changed_year_headers
    prefix = if AS_AT_DATE_PREFIX_QUESTION_KEYS.include?(question.key)
      AS_AT_DATE_PREFIX
    else
      YEAR_ENDING_IN_PREFIX
    end

    financial_table_headers.map do |i|
      "#{prefix} #{i}"
    end
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
    day = form_pdf.filled_answers["financial_year_date_day"].to_s

    month = if with_month_check
      to_month(form_pdf.filled_answers["financial_year_date_month"])
    else
      form_pdf.filled_answers["financial_year_date_month"]
    end.to_s

    day = "0" + day if day.size == 1
    month = "0" + month if month.size == 1

    [day, month, Date.today.year ]
  end
end
