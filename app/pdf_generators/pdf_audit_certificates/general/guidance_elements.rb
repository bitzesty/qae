# coding: utf-8
module PdfAuditCertificates::General::GuidanceElements
  def render_guidance_intro
    header = "GUIDANCE FOR ACCOUNTANTS"

    render_text_line(header, 3, style: :bold)

    if form_answer.trade? || form_answer.mobility?
      table = "table"
    else
      table = "tables"
    end

    p1 = "The figures in the #{table} below have been provided by the applicant during their application for the Queen’s Awards for Enterprise."

    p2 = "Please review the figures. If they are all correct, please confirm this by selecting Statement 1 at the bottom of this form. Alternatively, please enter the revised figures in the #{table}, explain the changes in the section provided below the #{table} and select Statement 2."

    p3 = "Please note, justifiable changes that do not substantially change the applicant’s overall financial performance are unlikely to disqualify the applicant."

    [p1, p2, p3].each do |paragraph|
      render_text_line(paragraph, 2, leading: 2)
    end
  end

  def render_guidance_general_notes
    header = "General notes"

    render_text_line(header, 1, style: :bold)

    p1 = "A parent company making a group entry should include the trading figures of all UK members of the group."

    p2 = "The financial figures should be in pound sterling (£)."

    p3 = "Use a minus symbol to record any losses."

    [p1, p2, p3].each do |paragraph|
      render_text_line(paragraph, 1, leading: 2)
    end
  end

  def render_guidance_estimated_figures
    header = "Estimated figures"

    render_text_line(header, 1, style: :bold)

    paragraph = "The applicant had to submit data for their latest financial year that fell before the #{Settings.current_submission_deadline.strftime('%d %b %Y')} (the submission deadline). If they haven't reached or finalised their latest year-end by then, they were able to provide estimated figures, provided the actual figures can be provided at this verification stage by an independent accountant."
    render_text_line(paragraph, 1, leading: 2)
  end

  def render_guidance_employees
    header = "Number of UK employees"

    render_text_line(header, 1, style: :bold)

    paragraph = "The number of people employed by the organisation in the UK in each year of the entry. You can use the number of full-time employees at the year-end, or the average for the twelve-month period. Part-time employees should be expressed in full-time equivalents."
    render_text_line(paragraph, 1, leading: 2)
  end

  def render_guidance_overseas_sales
    header = "Overseas sales"

    render_text_line(header, 1, style: :bold)
    lines = []
    lines << "Include only:"
    lines << "Direct overseas sales of all products and services (including income from royalties, licence fees, provision of know-how)."
    lines << "Total export agency commissions."
    lines << "Dividends remitted to the UK from direct overseas investments."
    lines << "Income from portfolio investment abroad remitted to the UK."
    lines << "Dividends on investments abroad not remitted to the UK."
    lines << "Other earnings from overseas residents remitted to the UK."

    lines.each do |line|
      render_text_line(line, 1)
    end

    move_down 3.mm

    p1 = "If applicable, include the sales to, and the sales by the overseas branches or subsidiaries. For products/services which the applicant sells/invoices to them and they sell/invoice on, include only their mark-up, if any, over the price paid to the applicant."

    p2 = "The products/services must have been shipped/provided and the customer invoiced, but the applicant need not have received the payment within the year concerned. Omit unfulfilled orders and payments received in advance of export."

    [p1, p2].each do |paragraph|
      render_text_line(paragraph, 1, leading: 2)
    end
  end
end
