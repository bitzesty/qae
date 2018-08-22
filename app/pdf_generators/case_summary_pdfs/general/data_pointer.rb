# -*- coding: utf-8 -*-
module CaseSummaryPdfs::General::DataPointer
  PREVIOUS_AWARDS = { "innovation" => "Innovation",
                      "international_trade" => "International Trade",
                      "sustainable_development" => "Sustainable Development" }

  COLOR_LABELS = %w(positive average negative neutral)
  POSITIVE_COLOR = "6B8E23"
  AVERAGE_COLOR = "DAA520"
  NEGATIVE_COLOR = "FF0000"
  NEUTRAL_COLOR = "ECECEC"

  def undefined_value
    FeedbackPdfs::Pointer::UNDEFINED_VALUE
  end

  def current_awards_question
    all_questions.detect do |q|
      q.delegate_obj.is_a?(QAEFormBuilder::QueenAwardHolderQuestion)
    end
  end

  def organisation_type
    filled_answers["organisation_type"].capitalize
  end

  def application_type_question
    all_questions.detect do |q|
      q.delegate_obj.is_a?(QAEFormBuilder::CheckboxSeriaQuestion) &&
      q.application_type_question.present?
    end
  end

  def application_type_answer
    filled_answers[application_type_question.key.to_s]
  end

  def application_type
    application_type_answer.map do |option|
      application_type_question.check_options.detect do |p_o|
        p_o[0].to_s == option["type"].to_s
      end[1]
    end.join(" / ")
  end

  def sic_code
    form_answer.decorate.sic_code_name || undefined_value
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
        res = answer.map do |item|
          if item["category"].present? && item["year"].present?
            "#{item["year"]} - #{PREVIOUS_AWARDS[item["category"].to_s]}"
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
        value[:label].delete(":"),
        data["#{key}_desc"] || undefined_value,
        value[:type] == :non_rag ? "" : rag(key, value)
      ]
    end
  end

  def rag_source(value)
    case value[:type]
    when :rag
      if value[:label].include?("Corporate social responsibility")
        AppraisalForm.const_get("CSR_RAG_OPTIONS_#{@award_year.year}")
      else
        AppraisalForm.const_get("RAG_OPTIONS_#{@award_year.year}")
      end
    when :verdict
      AppraisalForm.const_get("VERDICT_OPTIONS_#{@award_year.year}")
    when :strengths
      AppraisalForm.const_get("STRENGTH_OPTIONS_#{@award_year.year}")
    end
  end

  def rag(key, value)
    if data["#{key}_rate"].present?
      val = rag_source(value).detect do |el|
        el[1] == data["#{key}_rate"]
      end

      val.present? ? val[0] : undefined_value
    else
      undefined_value
    end
  end

  def render_data!
    if form_answer.trade?
      render_financial_block(true)

      pdf_doc.move_down 10.mm
      render_application_background
    else
      pdf_doc.move_down y_coord('general_block').mm
      render_application_background
    end

    pdf_doc.move_down 7.mm
    render_case_summary_comments

    render_financial_block(false) unless form_answer.trade?
  end

  def render_financial_block(trade_mode)
    if financial_pointer.present? && !financial_pointer.period_length.zero?
      move_length = 3.mm

      if trade_mode.present?
        move_length = y_coord('general_block').mm
      end

      pdf_doc.move_down move_length
      render_financial_table
    end
  end

  def render_application_background
    pdf_doc.stroke_horizontal_rule
    pdf_doc.move_down 7.mm
    pdf_doc.text "Application background", header_text_properties.merge({size: 13})
    pdf_doc.move_down 5.mm
    pdf_doc.text data["application_background_section_desc"], header_text_properties.merge({style: :normal})
    pdf_doc.move_down 7.mm
    pdf_doc.stroke_horizontal_rule
  end

  def render_case_summary_comments
    render_case_summaries_header
    render_items
  end

  def render_case_summaries_header
    pdf_doc.text "Case summary comments", header_text_properties.merge({size: 13})
  end

  # Classes and methods are not available inside pdf_doc.table below (Prawn::Table)
  # but constants for current class are available
  # so, that we are setting them here
  COLOR_LABELS.each do |label|
    AppraisalForm::SUPPORTED_YEARS.each do |year|
      const_set("#{label.upcase}_LABELS_#{year}", AppraisalForm.group_labels_by(year, label))
    end
  end

  def render_items
    year = @award_year.year

    pdf_doc.move_down 5.mm

    case_summaries_entries.each_with_index do |entry, index|

      if index > 0
        pdf_doc.stroke_horizontal_rule
        pdf_doc.move_down 5.mm
      end

      pdf_doc.text entry[0], header_text_properties

      pdf_doc.text entry[2], header_text_properties.merge({color: color_by_value(entry[2], year)})

      pdf_doc.move_down 5.mm

      pdf_doc.text entry[1], header_text_properties.merge({style: :normal})
      pdf_doc.move_down 5.mm
    end
  end

  def color_by_value(val, year)
    COLOR_LABELS.map do |label|
      if CaseSummaryPdfs::Pointer.const_get("#{label.upcase}_LABELS_#{year}").include?(val)
        return self.class.const_get("#{label.upcase}_COLOR")
      end
    end
  end

  def render_financial_table
    render_financial_section_header
    render_financial_table_header
    render_financials
    render_financial_benchmarks
  end

  def render_financial_section_header
    pdf_doc.stroke_horizontal_rule
    pdf_doc.move_down 10.mm
    pdf_doc.text "Financial Summary", header_text_properties.merge({size: 13})
    pdf_doc.move_down 5.mm
  end

  def render_financial_table_header
    pdf_doc.table [year_rows], row_colors: %w(FFFFFF),
                  cell_style: { size: 12, font_style: :bold },
                  column_widths: column_widths
  end

  def render_financials
    rows = [date_rows]

    financial_metrics_by_years.map do |row|
      rows << row
    end

    pdf_doc.table(rows,
      cell_style: { size: 12 },
      column_widths: column_widths
    )
  end

  def column_widths
    first_row_width = case financial_pointer.period_length
    when 2
      first_row_width = 607
    when 3
      first_row_width = 527
    when 5
      first_row_width = 367
    when 6
      first_row_width = 287
    end

    res = { 0 => first_row_width }

    financial_pointer.period_length.times do |i|
      res[i + 1] = 80
    end

    res
  end

  def benchmarks_column_widths
    first_row_width = case financial_pointer.period_length
    when 2
      {
        0 => 607,
        1 => 160
      }
    when 3
      {
        0 => 527,
        1 => 240
      }
    when 5
      {
        0 => 367,
        1 => 400
      }
    when 6
      {
        0 => 287,
        1 => 480
      }
    end
  end

  def render_financial_benchmarks
    pdf_doc.move_down 5.mm
    # Removed due to lack of data
    # render_financial_table_header
    # render_base_growth_table if @form_answer.trade?

    # pdf_doc.move_down 10.mm
    render_overall_growth_table
  end

  def render_base_growth_table
    rows = [
        @growth_overseas_earnings_list.unshift("% Growth overseas earnings"),
        @sales_exported_list.unshift("% Sales exported"),
        @average_growth_for_list.unshift("% Sector average growth")
    ]

    pdf_doc.table(rows,
      cell_style: { size: 12 },
      column_widths: column_widths
    )
  end

  def render_overall_growth_table
    rows = [
      [
        "Overall growth in £ (year 1 - #{financial_pointer.period_length})",
        @overall_growth
      ],
      [
        "Overall growth in % (year 1 - #{financial_pointer.period_length})",
        @overall_growth_in_percents
      ]
    ]

    pdf_doc.table(rows,
      cell_style: { size: 12 },
      column_widths: benchmarks_column_widths
    )
  end
end
