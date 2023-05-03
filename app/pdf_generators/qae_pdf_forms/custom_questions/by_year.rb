module QaePdfForms::CustomQuestions::ByYear
  EMPTY_STRING = "".freeze
  YEAR_LABELS = %w(day month year).freeze
  FORMATTED_FINANCIAL_YEAR_WITH_DATE = "Financial year %<index>d ended %<date>s".freeze
  FORMATTED_FINANCIAL_YEAR_WITHOUT_DATE = "Financial year %<index>d".freeze
  FORMATTED_AS_AT_DATE = "As at %<date>s".freeze
  AS_AT_DATE_PREFIX_QUESTION_KEYS = [:total_net_assets].freeze
  ANSWER_FONT_START = "<color rgb='#{FormPdf::DEFAULT_ANSWER_COLOR}'>".freeze
  ANSWER_FONT_END = "</color>".freeze
  CALCULATED_FINANCIAL_DATA = [:uk_sales].freeze
  OMIT_COLON_KEYS = [:financial_year_changed_dates].freeze

  def render_years_labels_table
    rows = financial_table_changed_dates_headers.map do |a|
      a.split("/")
    end

    # rows.push(latest_year_label)

    financial_dates_year_headers(format: FORMATTED_FINANCIAL_YEAR_WITHOUT_DATE).each_with_index do |header_item, placement|
      form_pdf.default_bottom_margin
      title = if OMIT_COLON_KEYS.include?(question.key)
                "#{header_item} #{ANSWER_FONT_START}#{rows[placement].join("/")}#{ANSWER_FONT_END}"
              else
                "#{header_item}: #{ANSWER_FONT_START}#{rows[placement].join(" ")}#{ANSWER_FONT_END}"
              end

      form_pdf.text title, inline_format: true
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
        entry = year_entry(field).to_s.delete(",")
        entry.present? ? ApplicationController.helpers.number_with_delimiter(entry) : EMPTY_STRING
      end
    end

    render_single_row_list(year_headers, rows)
  end

  def year_headers
    financial_dates_year_headers
  end

  def financial_dates_year_headers(**opts)
    if form_pdf.pdf_blank_mode.present? # BLANK FOR MODE
      financial_table_default_headers.map.with_index do |item, index|
        financial_table_default_headers.size == (index + 1) ? "#{item} (most recent)" : item
      end
    else
      frmt = opts.dig(:format)
      res = []
      size = financial_table_headers.size

      financial_table_headers.each_with_index do |item, idx|
        if AS_AT_DATE_PREFIX_QUESTION_KEYS.include?(question.key)
          frmt ||= FORMATTED_AS_AT_DATE
          res << format(frmt, date: item)
        else
          parts = item.split("/")

          # After splitting by `/` date should always have 3 parts and none of them should be blank.
          if parts.any?(&:blank?) || parts.size < 3
            frmt = FORMATTED_FINANCIAL_YEAR_WITHOUT_DATE
          end

          frmt ||= FORMATTED_FINANCIAL_YEAR_WITH_DATE

          temp = format(frmt, date: item, index: idx.to_i)
          temp = "#{temp} (most recent)" if size == (idx.to_i + 1)
          res << temp
       end
      end

      res
    end
  end

  def year_ended?
    day = form_pdf.filled_answers["financial_year_date_day"].to_s
    month = form_pdf.filled_answers["financial_year_date_month"].to_s

    # Conditional latest year
    # If from 3rd of September to December -> then previous year
    # If from January to 2nd of September -> then current year
    #

    (month.to_i == 9 && day.to_i >= 3) || month.to_i > 9
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
    month_number = form_pdf.filled_answers["financial_year_date_month"]
    month = if with_month_check
      to_month(month_number)
    else
      month_number
    end.to_s

    year = Date.today.year
    year -= 1 if year_ended?

    day = "0" + day if day.size == 1
    month = "0" + month if month.size == 1

    [day, month, year]
  end
end
