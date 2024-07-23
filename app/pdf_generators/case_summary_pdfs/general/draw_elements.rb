module CaseSummaryPdfs::General::DrawElements
  ONE_LINE_OFFSET = 8.mm

  def default_offset
    SharedPdfHelpers::DrawElements::DEFAULT_OFFSET
  end

  def sic_code_offset
    @sic_code_offset ||= if sic_code.length > 100
      -5.mm
    else
      0.mm
    end
  end

  def social_media_links_offset
    @_social_media_links_offset ||= case social_media_links.size
      when 0..1 then 0
      when 2..3 then -2.5.mm
      when 4..6 then -5.mm
      else -7.5.mm
    end
  end

  def main_header
    render_official_sensitive(105, 137.5)
    render_logo(695, 127.5)
    render_urn(0, 127)
    render_applicant(0, 119.5)

    unless form_answer.promotion?
      render_organization_type
      render_sic_code
      render_website_address(offset: sic_code_offset)
      render_social_media_links(offset: sic_code_offset)

      if (form_answer.development? || form_answer.mobility?) && form_answer.award_year.year >= 2020
        # type and sub category Qs are missing for SD2020+, so need to move up
        render_current_awards(offset: ONE_LINE_OFFSET + sic_code_offset + social_media_links_offset)
      else
        render_type(offset: sic_code_offset + social_media_links_offset)
        render_current_awards(offset: sic_code_offset + social_media_links_offset)
        render_sub_category(0, y_coord("sub_category") + sic_code_offset.to_i + (social_media_links_offset / 3)) # No idea why division by 3 is needed but it seems to work and offset the text properly
      end
    else
      render_website_address(offset: 15.mm)
      render_social_media_links(offset: 15.mm)
    end

    render_award_general_information(130, 142)
    render_award_title(130, 134.5)
  end

  def render_organization_type
    pdf_doc.text_box "<b>Organisation Type:</b> #{organisation_type}", description_list_properties.merge(
      at: [0.mm, 112.mm + default_offset],
    )
  end

  def render_type(offset: 0.mm)
    pdf_doc.text_box "<b>Type:</b> #{application_type}",
      description_list_properties.merge(
        at: [0.mm, 82.mm + default_offset + offset],
        width: 272.mm,
      )
  end

  def y_coord(mode)
    mode_number = case mode
    when "awards"
      0
    when "sub_category"
      1
    when "general_block"
      2
    end

    if form_answer.award_type == "mobility" &&
        form_answer.award_year.year < 2020 &&
        application_type_answer.size > 0
      case application_type_answer.size
      when 1
        [64, 56, 90] # [79, 71, 75] <~ ORIGINAL VALUES
      when 2
        [59, 52, 96] # [74, 67, 81] <~ ORIGINAL VALUES
      when 3
        [54, 47, 100] # [69, 62, 85] <~ ORIGINAL VALUES
      end
    else
      [74, 66, 80] # [89, 81, 65] <~ ORIGINAL VALUES
    end[mode_number]
  end

  def render_sic_code
    pdf_doc.text_box "<b>SIC code:</b> #{sic_code}",
      description_list_properties.merge(width: 272.mm, at: [0.mm, 104.5.mm + default_offset])
  end

  def render_website_address(offset: 0)
    pdf_doc.formatted_text_box(
      [
        { text: "Website address: ", styles: [:bold], **description_list_properties },
        { text: website_url, link: website_url, styles: [:underline], color: "035DA5", **description_list_properties }
      ],
      at: [0.mm, 97.mm + default_offset + offset],
      width: 272.mm
    )
 end

  def render_social_media_links(offset: 0)
    pdf_doc.formatted_text_box(
      [
        { text: "Links to social media accounts: ", styles: [:bold], **description_list_properties },
        { text: social_media_links.join(", "), **description_list_properties }
      ],
      at: [0.mm, 89.5.mm + default_offset + offset],
      width: 272.mm
    )

    pdf_doc.move_down(social_media_links_offset.abs)
  end

  def render_current_awards(offset: 0)
    awards = current_awards
    awards = [awards] if awards.is_a?(String)

    awards.each_with_index do |awards_line, index|
      if index == 0
        pdf_doc.text_box "<b>Current Awards:</b> #{awards_line}",
          description_list_properties.merge(width: 650.mm, at: [0.mm, y_coord("awards").mm + default_offset + offset])
      else
        pdf_doc.text_box awards_line.to_s,
          header_text_properties.merge(width: 650.mm, at: [0.mm, y_coord("awards").mm + default_offset + offset - index * ONE_LINE_OFFSET])

        pdf_doc.move_down ONE_LINE_OFFSET
      end
    end
  end
end
