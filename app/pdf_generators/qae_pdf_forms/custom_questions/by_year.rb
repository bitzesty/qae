module QaePdfForms::CustomQuestions::ByYear
  YEAR_LABELS = %w(day month year)
  FINANCIAL_YEAR_PREFIX = "Financial year"
  YEAR_ENDING_IN_PREFIX = "Year ending in"
  AS_AT_DATE_PREFIX = "As at"
  AS_AT_DATE_PREFIX_QUESTION_KEYS = [
    :total_net_assets
  ]
  ANSWER_FONT_START = "<font name='Times-Roman'><color rgb='#{FormPdf::DEFAULT_ANSWER_COLOR}'>"
  ANSWER_FONT_END = "</font></color>"
  CALCULATED_FINANCIAL_DATA = [
    :uk_sales
  ]

  def render_years_labels_table
    rows = financial_table_changed_dates_headers.map do |a|
      a.split("/")
    end

    rows.map do |e|
      e[1] = to_month(e[1])
    end
    rows.push(latest_year_label)

    year_headers.each_with_index do |header_item, placement|
      form_pdf.default_bottom_margin
      title = "#{header_item}: #{ANSWER_FONT_START}#{rows[placement].join(" ")}#{ANSWER_FONT_END}"
      form_pdf.text title,
                    inline_format: true
    end
  end

  def render_years_table
    rows = if CALCULATED_FINANCIAL_DATA.include?(question.key)
      res = get_audit_data(question.key).map do |field|
        ApplicationController.helpers.formatted_uk_sales_value(field)
      end

      res.all? { |el| el == {}} ? [] : res
    else
      active_fields.map do |field|
        entry = year_entry(field).to_s.gsub(",", "")
        entry.present? ? ApplicationController.helpers.number_with_delimiter(entry) : ""
      end
    end

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
      financial_year_changed_dates_value.present? ? YEAR_ENDING_IN_PREFIX : ""
    end

    if form_pdf.pdf_blank_mode.present? # BLANK FOR MODE
      financial_table_default_headers.map.with_index do |item, index|
        financial_table_default_headers.size == (index + 1) ? "#{item} (Current)" : item
      end
    else
      financial_table_headers.map do |i|
        "#{prefix} #{i}"
      end
    end
  end

  def active_fields
    question.decorate(answers: form_pdf.filled_answers).active_fields
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
