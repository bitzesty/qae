module PdfAuditCertificates::General::SharedElements
  DEFAULT_OFFSET = 110.mm

  def render_main_header
    render_certificate_info
    render_company_info
    render_urn

    move_down 30.mm
  end

  def render_certificate_info
    title = "THE QUEEN’S AWARDS FOR ENTERPRISE #{form_answer.award_year}: AUDITOR’S CERTIFICATE"
    text_box title,
             default_text_header_ops.merge(at: [0.mm, 145.mm + DEFAULT_OFFSET])
  end

  def render_company_info
    text_box "COMPANY NAME: #{form_answer.company_name}",
             default_text_header_ops.merge(at: [0.mm, 133.mm + DEFAULT_OFFSET])
  end

  def render_urn
    text_box "QA REF: #{form_answer.urn}",
             default_text_header_ops.merge(at: [0.mm, 128.mm + DEFAULT_OFFSET])
  end

  def render_base_paragraph
    p1 = %{This certificate should confirm all the figures quoted in the table below, or as amended in the revised table on page 2. By completing this certificate, you are confirming that you have carried out such work as you consider necessary to confirm the relevant figures and that the applicant has complied with the accounting standards applicable to the applicant status in preparing the entry.}

    text p1, default_text_ops.merge({ :leading => 2.2 })
    move_down 5.mm

    p2 = "If you tick option 1, then you should only complete the signatory and company details below. If you tick option 2, you should complete the signatory and company details below and revise the figures in the table on page 2 of this form, initial and provide an explanation of the changes. This certificate should be completed in writing on a printed copy of this document. Please return the completed certificate to your client."

    text p2, default_text_ops.merge({ :leading => 2.2 })
    move_down 5.mm
  end

  def render_user_filling_block

  end

  def render_revised_schedule

  end

  def render_explanation_of_the_changes

  end

  def render_additional_comments

  end

  def render_options

  end

  def render_footer_note

  end

  def default_text_header_ops
    default_text_ops.merge({
      height: 20.mm,
      style: :bold,
      size: 11.5
    })
  end

  def default_text_ops
    {
      size: 8.99,
      align: :justify
    }
  end
end
