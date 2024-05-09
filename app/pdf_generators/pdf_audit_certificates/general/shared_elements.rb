module PdfAuditCertificates::General::SharedElements
  DEFAULT_OFFSET = 110.mm
  NOT_CURRENCY_QUESTION_KEYS = %w(employees)

  def render_main_header
    render_certificate_info
    render_recipients_info
    render_company_info
    render_urn

    move_down 5.mm
  end

  def render_certificate_info
    title = "The King's Awards for Enterprise #{form_answer.award_year.year}: External Accountant’s Report"
    render_text_line(title, 5, default_text_header_ops.merge(align: :left))
  end

  def render_recipients_info
    render_text_line("<b>To</b>: The Kings Award’s Office, The Department for Business, Energy & Industrial Strategy", 1, inline_format: true)
  end

  def render_company_info
    render_text_line("<b>Applicant company name</b>: #{form_answer.company_name}", 1, inline_format: true)
  end

  def render_urn
    render_text_line("<b>KA ref</b>: #{form_answer.urn}", 1, inline_format: true)
  end

  def render_base_paragraph
    p1 = %{We have performed the work agreed with #{form_answer.company_name} in line with the requirements set out in the document “King’s Awards for Enterprise: #{form_answer.award_type_full_name} #{form_answer.award_year.year}” which constitutes the application form for the award.}
    render_text_line(p1, 2, { leading: 2 })

    p2 = "Our work was carried out solely to assist your process for considering #{form_answer.company_name} for a King’s Awards for Enterprise. We have reviewed the figures provided by #{form_answer.company_name} in section C of the application form.  We have used the guidance in section C of the application form of the as our own guidance in terms of the information that #{form_answer.company_name} should have provided. "
    render_text_line(p2, 2, { leading: 2 })
  end

  ###################################
  # Financial Data: Version 2 - begin
  ###################################

  def render_financial_table
    render_text_line("FIGURES TO BE REVISED OR VERIFIED", 3, style: :bold)
    render_financial_main_table
    # Uncomment lines below if need to display
    # benchmark tables too
    #
    # render_financial_benchmarks
  end

  def render_financial_main_table
    rows = [
      financial_pointer.years_list.unshift(""),
      financial_table_year_and_date_data,
    ]

    rows << revised_row(rows.last.length - 1, 1)

    financial_pointer.data.each_with_index do |row, index|
      next if row[:financial_year_changed_dates]

      rows << if row[:uk_sales]
        render_financial_uk_sales_row(row, index + 2)
      else
        render_financial_row(row, index + 1)
      end

      rows << revised_row(row.values.first.length, index + 1)
    end

    table(rows, table_default_ops(:main_table)) do
      rows.each_with_index do |row, i|
        if row.first.include?("Revised")
          style(row(i), text_color: "808080")
        end
      end
    end
  end

  def revised_row(length, index)
    ["#{index}. Revised"] + [""] * length
  end

  def render_financial_uk_sales_row(row, index)
    res = ["#{index}. " + I18n.t("#{financials_i18_prefix}.uk_sales_row.uk_sales")]

    res += row.values.flatten.map do |field|
      formatted_uk_sales_value(field)
    end

    res
  end

  def render_date_row(row, index)
    res = ["#{index}. " + I18n.t("#{financials_i18_prefix}.years_row.financial_year_changed_dates")]
    res << row.values
    res.flatten
  end

  def render_financial_row(row, index, key: nil)
    award_specific_key = "row"
    key ||= row.keys.first

    if form_answer.innovation? && key == :sales
      award_specific_key = "innovation"
    end

    res = ["#{index}. " + I18n.t("#{financials_i18_prefix}.#{award_specific_key}.#{key}")]

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
    # Uncomment me if you need to display Year labels too like:
    # Year 1, Year 2
    #
    # rows = [
    #   benchmark_by_years_table_headers
    # ]

    rows = []

    rows += if form_answer.trade?
      [
        benchmarks_row("growth_overseas_earnings"),
        benchmarks_row("sales_exported"),
        # removing this until SIC codes are updated
        # benchmarks_row("average_growth_for")
      ]
    else
      [
        benchmarks_row("growth_in_total_turnover"),
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
    res = ["1. " + I18n.t("#{financials_i18_prefix}.years_row.financial_year_changed_dates")]

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
        formatted_uk_sales_value(financial_pointer.overall_growth),
      ],
      [
        "Overall growth in % (year 1 - #{financial_pointer.period_length})",
        formatted_uk_sales_value(financial_pointer.overall_growth_in_percents),
      ],
    ]

    table rows, table_default_ops(:overall_benchmarks)
  end

  ###################################
  # Financial Data: Version 2 - end
  ###################################

  def render_user_filling_block

    dotted_line = %{...............................................................................................................................}

    b1 = %{Signed (External Accountant) ............................................................................}
    render_text_line(b1, 1)
    render_text_line(dotted_line, 1)

    b2 = %{Company partnership name: ............................................................................}
    render_text_line(b2, 1)
    render_text_line(dotted_line, 1)

    b3 = %{Company registration number/Professional body practising certificate number: }
    render_text_line(b3, 1)
    render_text_line(dotted_line, 1)
    render_text_line(dotted_line, 1)

    b4 = %{Address: ..............................................................................................................}
    render_text_line(b4, 1)

    b5 = %{Telephone number: ...........................................................................................}
    render_text_line(b5, 1)

    b6 = %{Email: ...................................................................................................................}
    render_text_line(b6, 1)

    b7 = %{Date: ....................................................................................................................}
    render_text_line(b7, 5)
  end

  def render_applicants_management_statement
    move_down 6.mm
    render_text_line("APPLICANT’S MANAGEMENT’S STATEMENT (Only if providing revised figures)", 3, style: :bold)

    line = "We confirm we have updated the figures originally submitted in our application to The King’s Award for Enterprise. The revised figures should be used as the basis of our application."
    render_text_line(line, 2, default_text_ops)

    b1 = %{Signed ................................................................................................................}
    render_text_line(b1, 1)

    b2 = %{Job title: ..............................................................................................................}
    render_text_line(b2, 1)

    b3 = %{Company: ..........................................................................................................}
    render_text_line(b3, 1)

    move_down 6.mm
  end

  def render_revised_schedule
    render_text_line("Revised Schedule:", 1, style: :bold)
    title = %{Please revise the figure(s) requiring amendment in manuscript in the table below, and complete the note at the end of this page, explaining the changes.}
    render_text_line(title, 5)
  end

  def render_explanation_of_the_changes
    move_down 5.mm
    render_text_line("Explanation of any revisions:", 1, style: :bold)
    move_down 70.mm
  end

  def render_additional_comments
    render_text_line("Additional comments:", 50, style: :bold)
  end

  def render_accountant_statement
    render_text_line("EXTERNAL ACCOUNTANT'S STATEMENT", 2, style: :bold)

    move_down 6.mm
    stroke_rectangle [0, cursor], 7, 7

    lines = []

    first_line = "Statement 1 - We have checked the figures that the applicant’s management has provided in this form by undertaking the agreed upon procedures. We report that no exceptions were found and that all samples were traced to underlying evidence."
    render_text_line(first_line, 2, default_list_ops)

    lines << "Because the agreed upon procedures do not constitute either an audit or a review made in accordance with International Standards on Auditing or International Standards on Review Engagements (or relevant national standards or practices), we do not express any assurance on the form."

    lines << "Had we performed additional procedures, or had we performed an audit or review of the financial statements in accordance with International Standards on Auditing or International Standards on Review Engagements (or relevant national standards or practices), other matters might have come to our attention that would have been reported."

    lines.each { |line| render_text_line(line, 2, default_text_ops) }

    stroke_rectangle [0, cursor], 7, 7
    first_line = "Statement 2 - We have checked the figures that the applicant’s management have provided in this form. We identified a number of exceptions during our work which we enumerate here:"
    render_text_line(first_line, 2, default_list_ops)

    render_text_line("Details of exceptions", 2, default_list_ops.merge(indent_paragraphs: 20, style: :bold))
    move_down 60.mm

    line = "The applicant’s management have/have not [delete as appropriate] revised the figures in the form in response."
    render_text_line(line, 2, default_text_ops)
    render_text_line("Details of revisions", 2, default_list_ops.merge(indent_paragraphs: 20, style: :bold))
    move_down 70.mm

    lines = []

    lines << "These adjustments remove/do not remove [delete as appropriate] the impact of the exception."

    lines << "Because the above procedures do not constitute either an audit or a review made in accordance with International Standards on Auditing or International Standards on Review Engagements (or relevant national standards or practices), we do not express any assurance on the form."

    lines << "Had we performed additional procedures or had we performed an audit or review of the financial statements in accordance with International Standards on Auditing or International Standards on Review Engagements (or relevant national standards or practices), other matters might have come to our attention that would have been reported."
    lines.each { |line| render_text_line(line, 2, default_text_ops) }
  end

  def render_feedback
    render_text_line("FEEDBACK", 5, style: :bold)

    render_text_line("Immediate feedback", 1, style: :bold)
    render_text_line("We would appreciate any immediate feedback on this verification form or the financial information requested so that we can make improvements for future applicants and their accountants.", 2, default_text_ops)
    move_down 60.mm

    render_text_line("Would you be willing to participate in our anonymous survey?", 1, style: :bold)

    render_text_line("We are committed to improving experiences for everyone who is involved in The King’s Awards for Enterprise process. We would like to gather feedback from accountants so that we can make relevant improvements to the verification forms and the financial section of the application form.", 5)

    render_text_line("Yes       No", 10, style: :bold)

    render_text_line("If you have agreed to participate in the survey, please provide your email address so that we can send it to you.", 3, style: :bold)

    render_text_line("Email: ....................................................................................................................", 1)
  end

  def render_appendix
    render_text_line("Appendix 1: Illustrative Agreed Upon Procedures", 6, style: :bold)

    ps = []

    ps << "The figures in the forms are provided by the applicant during their application for The King’s Awards for Enterprise. The King’s Awards for Enterprise requests that applicants engage an external accountant to check the submitted figures. For the avoidance of doubt, this should not be an assurance engagement, but an agreed upon procedures engagement."

    ps << "Accountants should exercise their professional judgement when agreeing appropriate procedures, and this appendix provides illustrative procedures that may be appropriate."

    ps.each { |pr| render_text_line(pr, 2, default_text_ops) }

    header = "Turnover:"
    list = [
      "Agree the total turnover figure per the form to the general ledger (account number [xxx]) for each year stated.",
      "Agree the total turnover figure per the form to HMRC and/or Companies House filings for each year stated.",
      "Trace a sample of 5% sales from the general ledger for each year to underlying sales invoices.",
    ]
    render_list_with_header(header, list)

    header = "Employees:"
    list = [
      "Agree the total number of full-time employees in the form to [name of payroll report] for each year stated.",
    ]
    render_list_with_header(header, list)

    header = "Overseas sales (Non-UK sales):"
    list = [
      "Agree the total non-UK sales per the form to the general ledger (account number [xxx]) for each year stated.",
      "Trace a sample of 5% non-UK sales from the general ledger to underlying sales invoices.",
      "Please note, for International Trade applicants, we need to ensure the sales demonstrates growth each year of the application period.",
    ]
    render_list_with_header(header, list)

    header = "Sales by product group"
    list = [
      "Agree the total sales by product group per the form to the general ledger (account numbers [xxx] and [xxx]).",
      "Trace a sample of 5% sales from the general ledger to underlying sales invoices.",
    ]
    render_list_with_header(header, list)

    header = "Net profit"
    list = [
      "Agree the value per the form to submissions to HMRC and/or Companies House for each year stated.",
    ]
    render_list_with_header(header, list)

    render_text_line("These examples are illustrative and other procedures may be undertaken. As a minimum, The King’s Awards for Enterprise expects at least one procedure is done per item in the report. For population sizes when tracing a sample to underlying evidence, The King’s Awards for Enterprise expects a sample size of 5% of the population (by quantity, not by value) subject to a maximum sample size of 25.", 5)
  end

  def render_list_with_header(header, list)
    render_text_line(header, 1, default_text_ops)

    list.each do |line|
      render_text_line("\u2022 " + line, 1, default_list_ops)
    end

    move_down 3.mm
  end


  def render_footer_note
    title = %{Note for applicants/auditors: This submission to the King's Awards Office (KAO) provides authority for the KAO to verify the information contained in it with the above-named auditor.}
    text_box title, default_text_ops.merge({
      at: [0.mm, 10.mm],
    })
  end

  def render_text_line(title, margin=0, ops={})
    text title, default_text_ops.merge(ops)
    move_down margin.mm
  end

  def render_text_box(title, top, options = {})
    text_box title,
      default_text_header_ops.merge(at: [0.mm, top.mm + DEFAULT_OFFSET]).merge(options)
  end

  def default_text_header_ops
    default_text_ops.merge({
      height: 20.mm,
      style: :bold,
      size: 11.5,
    })
  end

  def default_list_ops
    {
      leading: 1.8,
      indent_paragraphs: 10,
    }
  end

  def default_text_ops
    {
      size: 10,
      align: :justify,
    }
  end

  #############################################
  # Financial Data: Version 2 - table ops begin
  #############################################

  def table_default_ops(table_type)
    {
      column_widths: send("#{table_type}_column_widths"),
      cell_style: {
        size: 10,
        padding: [3, 3, 3, 3],
      },
    }
  end

  def main_table_column_widths
    res = case financial_pointer.years_list.size
    when 2
      [340, 100, 100]
    when 3
      [324, 72, 72, 72]
    when 5
      [180, 72, 72, 72, 72, 72]
    when 6
      [150, 65, 65, 65, 65, 65, 65]
    end

    hashed_columns(res)
  end

  def overall_benchmarks_column_widths
    res = case financial_pointer.years_list.size
    when 2
      [340, 200]
    when 3
      [324, 216]
    when 5
      [180, 360]
    when 6
      [150, 390]
    end

    hashed_columns(res)
  end

  def hashed_columns(arr)
    arr ||= []
    Hash[arr.map.with_index { |x, i| [i, x] }]
  end

  #############################################
  # Financial Data: Version 2 - table ops end
  #############################################
end
