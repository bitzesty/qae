module FeedbackPdfs::General::DataPointer
  COLOR_LABELS = %w[positive average negative neutral]

  POSITIVE_COLOR = "6B8E23"
  AVERAGE_COLOR = "DAA520"
  NEGATIVE_COLOR = "FF0000"
  NEUTRAL_COLOR = "ECECEC"

  COLOR_LABELS.each do |label|
    AppraisalForm::SUPPORTED_YEARS.each do |year|
      const_set(:"#{label.upcase}_LABELS_#{year}", AppraisalForm.group_labels_by(year, label))
    end
  end

  def undefined_value
    FeedbackPdfs::Pointer::UNDEFINED_VALUE
  end

  def feedback_table_headers
    [
      [
        "",
        "Key strengths",
        "Information to strengthen the application",
      ],
    ]
  end

  def feedback_entries
    FeedbackForm.fields_for_award_type(form_answer).map do |key, value|
      if value[:type] != :strengths
        [
          value[:label].delete(":"),
          data["#{key}_strength"] || undefined_value,
          data["#{key}_weakness"] || undefined_value,
        ]
      end
    end.compact
  end

  def strengths_entries
    FeedbackForm.fields_for_award_type(form_answer).map do |key, value|
      if value[:type] == :strengths
        [
          value[:label].delete(":"),
          rag(key),
        ]
      end
    end.compact
  end

  def render_data!
    table_items = feedback_entries

    render_overall_summary!
    render_headers(feedback_table_headers, {
      0 => 130,
      1 => 300,
      2 => 337,
    })
    render_table(table_items, {
      0 => 130,
      1 => 300,
      2 => 337,
    })

    if form_answer.development? && strengths_entries.present?
      year = form_answer.award_year.year

      pdf_doc.table(strengths_entries,
        cell_style: { size: 12 },
        column_widths: {
          0 => 130,
          1 => 637,
        }) do
        values = cells.columns(1).rows(0..-1)

        green_rags = values.filter do |cell|
          FeedbackPdfs::Pointer.const_get("POSITIVE_LABELS_#{year}").include?(cell.content.to_s.strip)
        end
        green_rags.background_color = POSITIVE_COLOR

        amber_rags = values.filter do |cell|
          FeedbackPdfs::Pointer.const_get("AVERAGE_LABELS_#{year}").include?(cell.content.to_s.strip)
        end
        amber_rags.background_color = AVERAGE_COLOR

        red_rags = values.filter do |cell|
          FeedbackPdfs::Pointer.const_get("NEGATIVE_LABELS_#{year}").include?(cell.content.to_s.strip)
        end
        red_rags.background_color = NEGATIVE_COLOR

        neutral_rags = values.filter do |cell|
          FeedbackPdfs::Pointer.const_get("NEUTRAL_LABELS_#{year}").include?(cell.content.to_s.strip)
        end
        neutral_rags.background_color = NEUTRAL_COLOR
      end
    end
  end

  def render_overall_summary!
    pdf_doc.move_down 30.mm
    render_table([["Overall Summary", data["overall_summary"]]], {
      0 => 130,
      1 => 637,
    })
  end

  def render_headers(table_lines, column_widths)
    pdf_doc.move_down 10.mm
    pdf_doc.table table_lines, row_colors: %w[F0F0F0],
      cell_style: { size: 12, font_style: :bold },
      column_widths: column_widths
  end

  def rag(key)
    if data["#{key}_rate"].present?
      val = AppraisalForm.const_get("STRENGTH_OPTIONS_#{form_answer.award_year.year}").detect do |el|
        el[1] == data["#{key}_rate"]
      end

      val.present? ? val[0] : undefined_value
    else
      undefined_value
    end
  end
end
