module QaePdfForms::GustomQuestions::FinancialDates
  def render_years_labels_table
    active_fields = question.decorate(answers: form_pdf.filled_answers).active_fields

    rows = active_fields[0..-2].map do |field|
      YEAR_LABELS.map do |year_label|
        fetch_year_label(year_label, field)
      end
    end

    rows.push(latest_year_label)
    active_fields.length.times do |i| 
      rows[i].unshift(i + 1)
    end

    render_multirows_table(YEAR_LABELS_TABLE_HEADERS, rows)
  end

  def fetch_year_label(year_label, field)
    sub_answer = form_pdf.filled_answers.detect do |k, v|
      k == "#{key}_#{field}#{year_label}"
    end

    if sub_answer.present?
      if year_label == 'month'
        to_month(sub_answer[1])
      else
        sub_answer[1]
      end
    else
      "-"
    end
  end

  def latest_year_label
    [
      '0' + form_pdf.filled_answers["financial_year_date_day"],
      to_month(form_pdf.filled_answers["financial_year_date_month"]),
      Date.today.year
    ]
  end
end