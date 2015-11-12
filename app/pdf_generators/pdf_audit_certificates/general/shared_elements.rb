module PdfAuditCertificates::General::SharedElements
  DEFAULT_OFFSET = 110.mm
  LIST_POINTER = "o   "
  NOT_CURRENCY_QUESTION_KEYS = %w(employees)

  def render_main_header
    render_certificate_info
    render_company_info
    render_urn

    move_down 22.mm
  end

  def render_certificate_info
    title = "THE QUEEN'S AWARDS FOR ENTERPRISE #{form_answer.award_year.year}: AUDITOR'S CERTIFICATE"
    render_text_box(title, 147)
  end

  def render_company_info
    render_text_box("COMPANY NAME: #{form_answer.company_name}", 137)
  end

  def render_urn
    render_text_box("QA REF: #{form_answer.urn}", 132)
  end

  def render_base_paragraph
    p1 = %{This certificate should confirm all the figures quoted in the table below, or as amended in the revised table on page 2. By completing this certificate, you are confirming that you have carried out such work as you consider necessary to confirm the relevant figures and that the applicant has complied with the accounting standards applicable to the applicant status in preparing the entry.}
    render_text_line(p1, 2, { leading: 2 })

    p2 = "If you tick option 1, then you should only complete the signatory and company details below. If you tick option 2, you should complete the signatory and company details below and revise the figures in the table on page 2 of this form, initial and provide an explanation of the changes. This certificate should be completed in writing on a printed copy of this document. Please return the completed certificate to your client."
    render_text_line(p2, 5, { leading: 2 })
  end

  ###################################
  # Financial Data: Version 1 - begin
  ###################################

  # def render_financial_table
  #   rows = [financial_table_headers.unshift("")]

  #   table_headers.map do |label|
  #     question_key = label["id"]

  #     rows << financial_data(
  #       question_key,
  #       get_audit_data(question_key)
  #     ).unshift(label["label"])
  #   end

  #   table rows, table_default_ops
  # end

  # def table_headers
  #   QuestionLabels::AuditCertificateLabel.find(form_answer.award_type).labels.reject do |l|
  #     # TODO: remove this rejecting once will be clear with unknown keys
  #     l["id"].blank?
  #   end
  # end

  # def number_with_delimiter(val)
  #   ApplicationController.helpers.number_with_delimiter(val)
  # end

  # def financial_data(question_key, question_data)
  #   question_data.map do |entry|
  #     if entry.is_a?(Array)
  #       entry.join("/")
  #     elsif entry.is_a?(Hash)
  #       data_by_type(question_key, entry)
  #     else # CALCULATED_DATA
  #       "£#{ApplicationController.helpers.formatted_uk_sales_value(entry)}"
  #     end
  #   end
  # end

  # def data_by_type(question_key, entry)
  #   if entry[:value].present?
  #     if NOT_CURRENCY_QUESTION_KEYS.include?(question_key)
  #       number_with_delimiter(entry[:value])
  #     else
  #       "£#{number_with_delimiter(entry[:value])}" if entry[:value] != "-"
  #     end
  #   end
  # end

  ###################################
  # Financial Data: Version 1 - end
  ###################################

  ###################################
  # Financial Data: Version 2 - begin
  ###################################

  def render_financial_table
    render_financial_main_table
    render_financial_benchmarks
  end

  def render_financial_main_table
    rows = [
      financial_pointer.years_list.unshift(""),
      financial_table_year_and_date_data
    ]

    financial_pointer.data.each_with_index do |row, index|
      next if row[:financial_year_changed_dates]

      rows << if row[:uk_sales]
        render_financial_uk_sales_row(row)
      else
        render_financial_row(row)
      end
    end

    table rows, table_default_ops(:main_table)
  end

  def render_financial_uk_sales_row(row)
    res = [I18n.t("#{financials_i18_prefix}.uk_sales_row.uk_sales")]

    res += row.values.flatten.map do |field|
      formatted_uk_sales_value(field)
    end

    res
  end

  def render_financial_row(row)
    res = [I18n.t("#{financials_i18_prefix}.row.#{row.keys.first}")]

    res += row.values.flatten.map do |field|
      number_with_delimiter(field[:value])
    end

    res
  end

  def render_financial_benchmarks
    move_down 3.mm
    render_financial_benchmarks_by_years
    move_down 3.mm
    render_financial_overall_benchmarks
  end

  def render_financial_benchmarks_by_years
    rows = [
      benchmark_by_years_table_headers
    ]

    rows += if form_answer.trade?
      [
        benchmarks_row("growth_overseas_earnings"),
        benchmarks_row("sales_exported"),
        benchmarks_row("sector_average_growth")
      ]
    else
      [
        benchmarks_row("growth_in_total_turnover")
      ]
    end

    table rows, table_default_ops(:main_table)
  end

  def benchmark_by_years_table_headers
    benchmark_year_headers = []

    financial_pointer.period_length.times do |i|
      benchmark_year_headers << "Year #{i + 1}"
    end

    benchmark_year_headers.unshift("")
  end

  def financial_table_year_and_date_data
    res = [I18n.t("#{financials_i18_prefix}.years_row.financial_year_changed_dates")]

    res += if financial_pointer.data.first[:financial_year_changed_dates].present?
      financial_pointer.financial_year_changed_dates
    else
      financial_pointer.financial_year_dates
    end

    res
  end

  def benchmarks_row(metric)
    res = [I18n.t("#{financials_i18_prefix}.benchmarks.#{metric}")]

    res += financial_pointer.send("#{metric}_list").map do |entry|
      formatted_uk_sales_value(entry)
    end

    res
  end

  def render_financial_overall_benchmarks
    rows = [
      [
        "Overall growth in £ (year 1 - #{financial_pointer.period_length})",
        formatted_uk_sales_value(financial_pointer.overall_growth)
      ],
      [
        "Overall growth in % (year 1 - #{financial_pointer.period_length})",
        formatted_uk_sales_value(financial_pointer.overall_growth_in_percents)
      ]
    ]

    table rows, table_default_ops(:overall_benchmarks)
  end

  ###################################
  # Financial Data: Version 2 - end
  ###################################

  def render_user_filling_block
    b1 = %{Signed ..................................................................................................................}
    render_text_line(b1, 1)

    b2 = %{For and on behalf of: ............................................................................................}
    render_text_line(b2, 1)

    b3 = %{Company Registration Number: ...........................................................................}
    render_text_line(b3, 5)

    b4 = %{Address: ...............................................................................................................}
    render_text_line(b4, 1)

    b5 = %{Telephone Number: ..............................................................................................}
    render_text_line(b5, 1)

    b6 = %{Email: ...................................................................................................................}
    render_text_line(b6, 5)

    b7 = %{Date: .....................................................................................................................}
    render_text_line(b7, 5)

    render_text_line(%{Company stamp:}, 5)
  end

  def render_revised_schedule
    render_text_line("Revised Schedule:", 1, {style: :bold, size: 10})
    title = %{Please revise the figure(s) requiring amendment in manuscript in the table below, and complete the note at the end of this page, explaining the changes.}
    render_text_line(title, 5)
  end

  def render_explanation_of_the_changes
    move_down 5.mm
    render_text_line("The following is an explanation of the changes:")
  end

  def render_additional_comments
    text_box "Additional Comments:", default_text_ops.merge({
      at: [0.mm, 35.mm]
    })
  end

  def render_options(opt1, opt2)
    move_down 6.mm
    render_text_line("#{LIST_POINTER}#{opt1}", 2, default_list_ops)
    render_text_line("#{LIST_POINTER}#{opt2}", 6, default_list_ops)
  end

  def render_footer_note
    title = %{Note for applicants/auditors: The submission of this Auditor's Certificate to the Queen's Awards Office (QAO) provides authority for the QAO to verify the information contained in it with the above-named auditor.}
    text_box title, default_text_ops.merge({
      at: [0.mm, 10.mm]
    })
  end

  def render_text_line(title, margin=0, ops={})
    text title, default_text_ops.merge(ops)
    move_down margin.mm
  end

  def render_text_box(title, top)
    text_box title,
             default_text_header_ops.merge(at: [0.mm, top.mm + DEFAULT_OFFSET])
  end

  def default_text_header_ops
    default_text_ops.merge({
      height: 20.mm,
      style: :bold,
      size: 11.5
    })
  end

  def default_list_ops
    {
      leading: 2.2,
      indent_paragraphs: 10
    }
  end

  def default_text_ops
    {
      size: 9,
      align: :justify
    }
  end


  #######################################
  # Financial Data: Version 1 - table ops
  #######################################
  # def table_default_ops
  #   {
  #     column_widths: {
  #       0 => 200
  #     },
  #     cell_style: {
  #       size: 10,
  #       padding: [3, 3, 3, 3]
  #     }
  #   }
  # end

  #############################################
  # Financial Data: Version 2 - table ops begin
  #############################################

  def table_default_ops(table_type)
    {
      column_widths: send("#{table_type}_column_widths"),
      cell_style: {
        size: 10,
        padding: [3, 3, 3, 3]
      }
    }
  end

  def main_table_column_widths
    res = case financial_pointer.years_list.size
    when 2
      [340, 100, 100]
    when 3
      [300, 50, 50, 50]
    when 5
      [300, 50, 50, 50, 50, 50]
    when 6
      [300, 50, 50, 50, 50, 50, 50]
    end

    hashed_columns(res)
  end

  def overall_benchmarks_column_widths
    res = case financial_pointer.years_list.size
    when 2
      [340, 200]
    when 3
      [300, 100]
    when 5
      [300, 100]
    when 6
      [300, 100]
    end

    hashed_columns(res)
  end

  def hashed_columns(arr)
    Hash[arr.map.with_index { |x, i| [i, x] }]
  end

  #############################################
  # Financial Data: Version 2 - table ops end
  #############################################
end
