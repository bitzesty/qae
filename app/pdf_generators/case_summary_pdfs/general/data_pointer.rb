module CaseSummaryPdfs::General::DataPointer
  PREVIOUS_AWARDS = { "innovation" => "Innovation",
                      "international_trade" => "International Trade",
                      "sustainable_development" => "Sustainable Development" }

  POSSIBLE_RAGS = {
    negative: "Red",
    average: "Amber",
    positive: "Green"
  }

  def undefined_value
    FeedbackPdfs::Pointer::UNDEFINED_VALUE
  end

  # EMPLOYEES BLOCK BEGIN

  def employees_question
    all_questions.detect do |q|
      q.delegate_obj.is_a?(QAEFormBuilder::ByYearsQuestion) &&
      q.employees_question.present?
    end
  end

  def employees_question_active_fields
    employees_question.decorate(answers: filled_answers).active_fields
  end

  def employees_by_years
    res = employees_question_active_fields.map do |field|
      employees_year_entry(field)
    end.compact

    res.present? ? res.map(&:to_s).max : undefined_value
  end

  def employees_year_entry(field)
    entry = filled_answers.detect do |k, _v|
      k == "#{employees_question.key}_#{field}"
    end

    entry[1] if entry.present?
  end

  def employees
    if employees_question.present?
      employees_by_years
    else
      undefined_value
    end
  end

  # EMPLOYEES BLOCK END

  def sic_code
    form_answer.sic_code || undefined_value
  end

  def current_awards_question
    all_questions.detect do |q|
      q.delegate_obj.is_a?(QAEFormBuilder::QueenAwardHolderQuestion)
    end
  end

  def current_awards
    if current_awards_question.present?
      answer = filled_answers[current_awards_question.key.to_s]

      if answer.present?
        res = JSON.parse(answer).map do |item|
          prepared_item = JSON.parse(item)

          if prepared_item["category"].present? && prepared_item["year"].present?
            "#{prepared_item["year"]} - #{PREVIOUS_AWARDS[prepared_item["category"].to_s]}"
          end
        end.compact

        res.present? ? res.join(", ") : undefined_value
      else
        undefined_value
      end
    else
      undefined_value
    end
  end

  def application_background_table_items
    [
      [
        "Application background",
        data["application_background_section_desc"]
      ]
    ]
  end

  def case_summaries_table_headers
    [
      [
        "Case summary comments",
        "RAG"
      ]
    ]
  end

  def case_summaries_entries
    AppraisalForm.struct(form_answer).map do |key, value|
      [
        value[:label].gsub(":", ""),
        data["#{key}_desc"] || undefined_value,
        data["#{key}_rate"].present? ? POSSIBLE_RAGS[data["#{key}_rate"].to_sym] : undefined_value
      ]
    end
  end

  def render_data!
    pdf_doc.move_down 50.mm
    render_application_background

    pdf_doc.move_down 10.mm
    render_case_summary_comments
  end

  def render_application_background
    render_table(application_background_table_items, {
      0 => 100,
      1 => 667
    })
  end

  def render_case_summary_comments
    render_case_summaries_header
    render_items
  end

  def render_case_summaries_header
    pdf_doc.table case_summaries_table_headers, row_colors: %w(FFFFFF),
                                                cell_style: { size: 12, font_style: :bold },
                                                column_widths: {
                                                  0 => 667,
                                                  1 => 100
                                                }
  end

  def render_items
    pdf_doc.table(case_summaries_entries,
                  cell_style: { size: 12 },
                  column_widths: {
                    0 => 100,
                    1 => 567,
                    2 => 100
                  }) do

      values = cells.columns(2).rows(0..-1)
      green_rags = values.filter do |cell|
        cell.content.to_s.strip == "Green"
      end
      green_rags.background_color = "6B8E23"

      amber_rags = values.filter do |cell|
        cell.content.to_s.strip == "Amber"
      end
      amber_rags.background_color = "DAA520"

      red_rags = values.filter do |cell|
        cell.content.to_s.strip == "Red"
      end
      red_rags.background_color = "FF0000"
    end
  end
end
