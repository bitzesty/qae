# coding: utf-8
module PdfAuditCertificates::General::GuidanceElements
  def render_applicant_guidance_section
    render_applicant_guidance_header
    move_down 3.mm
    render_applicant_guidance_text
    move_down 3.mm
  end

  def render_applicant_guidance_header
    header = "GUIDANCE FOR APPLICANTS"

    render_text_line(header, 3, style: :bold)
  end

  def render_applicant_guidance_text
    p1 = "We would like to inform you that your application has been shortlisted for a King's Award for Enterprise: #{award_type_short} category. To enable us to proceed with your entry, you are required to provide verification of the commercial figures you provided in your application. This verification must be from an external, qualified, practising accountant or auditor (as stated in the commercial performance section of the online entry form)."

    p2 = "We recommend that you send the report to the accountant straight away so that you can agree on the timelines. Let them know if you will be providing revisions to the figures."

    p3 = "As a shortlisted applicant, you now need to check the figures which you have provided. If you need to make changes or provide actual figures to replace estimates submitted at the time of application, please make changes on this form and then ask your external accountant to complete this. If you have made changes, then you will need to sign the Applicant’s Management’s Statement section of this form."

    p4 = "For applicants that are not for profit organisations or charities, to be eligible for a King’s Award for Enterprise, your organisation must be on a sustainable financial footing."

    p5 = "Once you and your external accountant have completed this report, please upload it to The King’s Awards for Enterprise online portal by #{Settings.current_audit_certificates_deadline.decorate.formatted_trigger_time(false)}. We are unable to accept late reports due to the strict assessment and judging timetable."

    [p1, p2, p3, p4, p5].each do |paragraph|
      render_text_line(paragraph, 2, leading: 2)
    end
  end


  def render_accountant_guidance_intro
    header = "GUIDANCE FOR ACCOUNTANTS"

    render_text_line(header, 3, style: :bold)

    if form_answer.innovation?
      table = "tables"
    else
      table = "table"
    end

    ps = []

    ps << "The figures in the #{table} below have been provided by the applicant during their application for The King’s Awards for Enterprise. Please check the figures the business has submitted to underlying calculations and compare these to a sample of underlying supporting documentation, including, where appropriate, filings with HMRC and/or Companies House. For the avoidance of doubt, we do not expect you to undertake an assurance engagement. We expect an agreed upon procedures engagement to be undertaken. Accountants should exercise their professional judgement when agreeing appropriate procedures. Appendix 1 provides illustrative procedures that may be appropriate and our expectations on sample sizes."

    ps << "If no exceptions are found, please confirm this by selecting Statement 1 in this form."

    ps << "If exceptions are found, but the applicant has adjusted these and explained the exchanges in the appropriate section to this form, then confirm this by selecting Statement 2."

    ps << "If exceptions are found, and they are not adjusted, this should be confirmed in Statement 2."

    ps << "We understand that the External Accountant’s Report has been prepared solely for the organisation’s exclusive use and solely for the purpose of the organisation’s application for The King’s Awards for Enterprise: #{header_full_award_type} #{form_answer.award_year.year}. However, we may request a copy of this Report solely for the purpose of enabling The King’s Award Office to further assess the application. The King’s Award Office accepts that the Accountant will accept no duty, liability or responsibility to The King’s Awards Office in relation to this Report. We will not use the Report for any other purpose, recited or referred to in any document, copied or made available (in whole or in part) to any other person without the Accountant’s prior written express consent. We accept that the Accountant accepts no duty, responsibility or liability to any party, other than the company, in connection with the Report."

    ps << "Figures derived from financial statements should be based upon the Generally Accepted Accounting Principles (‘GAAP’) used by the company."

    ps.each do |paragraph|
      render_text_line(paragraph, 2, leading: 2)
    end
  end

  def render_accountant_guidance_parent_figures
    header = "Group/parent company/subsidiary figures"

    render_text_line(header, 1, style: :bold)

    pr = "A parent company making a group entry should include the trading figures of all UK members of the group (‘The UK business’). For example, if you are applying as a whole group, then we require figures for the whole group. For UK companies who have a foreign parent company, please only use figures for the UK entity as the Award is for UK businesses only."
    render_text_line(pr, 1, leading: 2)
  end

  def render_accountant_guidance_general_notes
    p1 = "The financial figures should be in pound sterling (£). Please note that all figures should be to the nearest pound, not rounded further. Rounded figures will be rejected."
    p2 = "Use a minus symbol to record any losses."

    [p1, p2].each do |paragraph|
      render_text_line(paragraph, 1, leading: 2)
    end
  end

  def render_accountant_guidance_estimated_figures
    header = "Estimated figures"

    render_text_line(header, 1, style: :bold)

    paragraph = "If the applicant hasn’t reached or finalised the relevant year-end by the application submission deadline, they were able to provide estimated figures, provided the actual figures are provided at this verification stage."

    render_text_line(paragraph, 1, leading: 2)
  end

  def render_accountant_guidance_employees
    header = "Number of UK employees"

    render_text_line(header, 1, style: :bold)

    paragraph = "The number of people employed by the organisation in the UK in each year of the entry. You can use the number of full-time employees at the year-end, or the average for the twelve-month period. Part-time employees should be expressed in full-time equivalents."
    render_text_line(paragraph, 1, leading: 2)
  end

  def render_accountant_guidance_overseas_sales
    header = "Overseas sales"

    render_text_line(header, 1, style: :bold)
    lines = []
    lines << "Please note, this relates to the UK applicant’s overseas sales."
    lines << "Include only:"
    lines << "Direct overseas sales of all products and services (including income from royalties, licence fees, provision of knowhow)."
    lines << "Total export agency commissions."
    lines << "Dividends remitted to the UK from direct overseas investments."
    lines << "Income from portfolio investment abroad remitted to the UK."
    lines << "Dividends on investments abroad not remitted to the UK."
    lines << "Other earnings from overseas residents remitted to the UK."

    lines.each do |line|
      render_text_line(line, 1)
    end

    move_down 3.mm

    p1 = "If applicable, include the sales to and the sales by the overseas branches or subsidiaries. For products/services which the applicant sells/invoices to them and they sell/invoice on, include only their mark-up, if any, over the price paid to the applicant."

    p2 = "The products/services must have been shipped/provided, and the customer invoiced, but the applicant need not have received the payment within the year concerned. Omit unfulfilled orders and payments received in advance of export."

    [p1, p2].each do |paragraph|
      render_text_line(paragraph, 1, leading: 2)
    end
  end

  def render_accountant_po_guidance
    render_text_line("Promoting Opportunity (through social mobility)", 1, style: :bold)

    paragraph = "Promoting opportunity is defined as per the gov.uk guidance. For the avoidance of doubt, Accountants are not asked to apply judgement in determining whether the financial values disclosed meet the requirements for a promoting opportunity award. This is left to the sole discretion of The King’s Award Office."
    render_text_line(paragraph, 1, leading: 2)
  end
end
