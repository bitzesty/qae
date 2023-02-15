# coding: utf-8
class AwardYears::V2024::QAEForms
  class << self
    def trade_step2
      @trade_step2 ||= proc do
        header :company_information_header, "" do
          section_info
          context %(
            <h3 class='govuk-heading-m'>About section B</h3>
            <p class='govuk-body'>
              The purpose of this section is to collect specific information that identifies your organisation, for example, your registration number and address. It is important that the details are accurate as they cannot be changed later. This information will also be used to enable The King's Awards Office to undertake due diligence checks with other government departments and agencies if your application is shortlisted.
            </p>
            <h3 class="govuk-heading-m">Small organisations</h3>
            <p class="govuk-body">
              King's Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all of the questions to a degree you can.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "About section B"],
            [:normal, %(
              The purpose of this section is to collect specific information that identifies your organisation, for example, your registration number and address. It is important that the details are accurate as they cannot be changed later. This information will also be used to enable The King's Awards Office to undertake due diligence checks with other government departments and agencies if your application is shortlisted.
              )
            ],
            [:bold, "Small organisations"],
            [:normal, %(
                King's Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all of the questions to a degree you can.
              )
            ]
          ]
        end

        options :applying_for, "Are you applying on behalf of your:" do
          ref "B 1"
          required
          option "organisation", "Whole organisation (with ultimate control)"
          option "division branch subsidiary", "A division, branch or subsidiary"
        end

        header :business_division_header, "" do
          classes "application-notice help-notice"
          context %(
            <p class="govuk-body">
              Where the form refers to your organisation, enter the details of your division, branch or subsidiary.
            </p>
          )
          conditional :applying_for, "division branch subsidiary"
        end

        text :company_name, "Full legal name of your organisation." do
          required
          ref "B 2"
          context %(
            <p class="govuk-hint">
              If your organisation is a company or charity, please make sure that the name provided is in line with the company or charity registration number.
            </p>
          )
        end

        text :brand_name, "Organisation name as you would like it to appear on award certificate and announcements." do
          classes "sub-question"
          sub_ref "B 2.1"
          required
          context %(
            <p class="govuk-hint">
              Usually, this is the same name as your organisation's full legal name.
            </p>
            <p class="govuk-hint">
              However, you may choose to include the name you are trading as or a brand name. If you do so, you may be asked to provide evidence that the legal entity uses the trading name or owns the brand. Also, the evidence in the application form must be clearly linked to the provided trading name or brand.
            </p>
          )
        end

        options :principal_business, "Does your organisation operate as a principal?" do
          required
          ref "B 3"
          context %(
            <p class="govuk-hint">
              We recommend that you apply as a principal. A principal invoices its customers (or their buying agents) and is the body to receive those payments.
            </p>
          )
          yes_no
        end

        textarea :invoicing_unit_relations, "Explain your relationship with the invoicing unit, and the arrangements made." do
          classes "sub-question word-max-strict"
          sub_ref "B 3.1"
          required
          conditional :principal_business, :no
          words_max 100
          rows 1
        end

        options :organisation_type, "What type of legal entity is your organisation?" do
          required
          ref "B 4"
          option "sole_trader", "Sole Trader"
          option "partnership", "Partnership"
          option "ltd", "Limited Company (Ltd)"
          option "plc", "Public Limited Company (Plc)"
          option "cic", "Community Interest Company (CIC)"
          option "charity", "Charity"
          option "other", "Other"
        end

        text :other_organisation_type, "" do
          context %{
            <p class="govuk-body">Please specify</p>
          }
          pdf_context %{
            <p class="govuk-body">Please specify if selected Other</p>
          }
          conditional :organisation_type, :other
        end

        text :registration_number, "Provide your company or charity registration number or enter 'N/A'." do
          required
          classes "sub-question"
          ref "B 4.1"
          context %(
            <p class="govuk-hint">
              If you're an unregistered subsidiary, enter your parent company's number.
            </p>
          )
          style "small"
        end

        text :vat_registration_number, "Provide your VAT registration number or enter 'N/A'." do
          required
          classes "sub-question"
          ref "B 4.2"
          context %(
            <p class="govuk-hint">If you're an unregistered subsidiary, enter your parent company's number.</p>
          )
          style "small"
        end

        date :started_trading, "Date started trading" do
          required
          ref "B 5"
          context %(
            <p class="govuk-hint">
              Organisations that began trading after #{AwardYear.start_trading_since(3)} aren't eligible for this award.
            </p>
          )
          date_max AwardYear.start_trading_since(3)
        end

        options :applied_for_queen_awards, "In the last ten years have you applied, whether you have won or not, for a King's/Queen's Awards for Enterprise award in any category?" do
          required
          ref "B 6"
          yes_no
          classes "queen-award-holder"
        end

        queen_award_applications :applied_for_queen_awards_details, "List the King's/Queen's awards you have applied for in the last 10 years." do
          classes "sub-question question-current-awards"
          sub_ref "B 6.1"

          conditional :applied_for_queen_awards, :yes

          category :innovation, "Innovation"
          category :international_trade, "International Trade"
          category :sustainable_development, "Sustainable Development"
          category :social_mobility, "Promoting Opportunity"

          ((AwardYear.current.year - 10)..(AwardYear.current.year - 1)).each do |y|
            year y
          end

          outcome "won", "Won"
          outcome "did_not_win", "Did not win"

          children_options_depends_on :category
          dependable_values [:international_trade]

          additional_pdf_context I18n.t("pdf_texts.trade.queen_awards_question_additional_context")
        end

        options_business_name_changed :business_name_changed, "Have you changed the name of your organisation since your last entry?" do
          classes "sub-question"
          sub_ref "B 6.2"

          option "yes", "Yes"
          option "no", "No"
          conditional :applied_for_queen_awards, :yes
        end

        text :previous_business_name, "Name used previously" do
          classes "sub-question"
          sub_ref "B 6.3"
          required
          conditional :applied_for_queen_awards, :yes
          conditional :business_name_changed, :yes
        end

        options :other_awards_won, "Have you won any other awards in the past?" do
          ref "B 7"
          required
          yes_no
        end

        textarea :other_awards_desc, "Please describe them." do
          classes "sub-question word-max-strict"
          sub_ref "B 7.1"
          required
          form_hint "If you can't fit all of your awards below, then choose those you're most proud of."
          conditional :other_awards_won, :yes
          rows 5
          words_max 250
        end

        address :organization_address, "Trading address of your organisation" do
          required
          ref "A 8"
          pdf_context_with_header_blocks [
            [:normal, "If you are based in one of London's 33 districts (32 London boroughs and the City of London), please select Greater London.\n"],
            [:normal, "See the full list of London districts on https://en.wikipedia.org/wiki/Greater_London"]
          ]
          county_context %(
            <p class='govuk-hint'>If you are based in one of London's 33 districts (32 London boroughs and the City of London), please select Greater London.</p>

            <p class='govuk-hint'>
              <a href="https://en.wikipedia.org/wiki/Greater_London" target="_blank" class="external-link govuk-link">
                See the full list of London districts on Wikipedia
              </a>
            </p>
          )
          sub_fields([
            { building: "Building" },
            { street: "Street" },
            { city: "Town or city" },
            { county: "County" },
            { postcode: "Postcode" }
          ])
        end

        text :org_telephone, "Main telephone number" do
          required
          ref "A 8.1"
          type "tel"
          style "small"
        end

        press_contact_details :press_contact_details, "Contact details for press enquiries" do
          ref "A 9"
          context %(
            <p class='govuk-hint'><em>
              If your application is successful, you may get contacted by the press.
            </em></p>
            <p class='govuk-hint'>
              Provide details of the most suitable person within the organisation to deal with the press. You will have the opportunity to update these at a later date if needed.
            </p>
          )
          sub_fields([
            { title: "Title" },
            { first_name: "First name" },
            { last_name: "Last name" },
            { telephone: "Telephone" },
            { email: "Email address" }
          ])
        end

        text :website_url, "Website address" do
          ref "A 10"
          style "large"
          form_hint "Please provide full website address, for example, www.yourcompanyname.com"
        end

        sic_code_dropdown :sic_code, "The Standard Industrial Classification (SIC) code" do
          required
          ref "A 11"
          form_hint "The Standard Industrial Classification (SIC) is a system for classifying industries. If you are a registered company, this is the same code you would have provided Companies House."
        end

        options :parent_group_entry, "Are you a parent company making a group entry?" do
          ref "A 12"
          form_hint "A 'group entry' is when you are applying on behalf of multiple divisions/branches/subsidiaries under your control."
          yes_no
        end

        options :pareent_group_excluding, "Are you excluding any members of your group from this application?" do
          classes "sub-question"
          sub_ref "A 12.1"
          conditional :parent_group_entry, "yes"
          yes_no
        end

        textarea :pareent_group_why_excluding_members, "Please explain why you are excluding any members of your group from this application." do
          classes "sub-question"
          sub_ref "A 12.2"
          rows 5
          words_max 100
          conditional :parent_group_entry, "yes"
          conditional :pareent_group_excluding, "yes"
        end

        options :has_parent_company, "Do you have a parent or a holding company?" do
          ref "A 13"
          yes_no
        end

        text :parent_company, "Name of immediate parent company" do
          classes "sub-question"
          sub_ref "A 13.1"
          conditional :has_parent_company, "yes"
        end

        country :parent_company_country, "Country of immediate parent company" do
          classes "sub-question"
          sub_ref "A 13.2"
          conditional :has_parent_company, "yes"
        end

        options :parent_ultimate_control, "Does your immediate parent company have ultimate control?" do
          classes "sub-question"
          sub_ref "A 13.3"
          conditional :has_parent_company, "yes"
          yes_no
        end

        text :ultimate_control_company, "Name of organisation with ultimate control" do
          classes "regular-question"
          sub_ref "A 13.4"
          conditional :has_parent_company, "yes"
          conditional :parent_ultimate_control, :no
        end

        country :ultimate_control_company_country, "Country of organisation with ultimate control" do
          classes "regular-question"
          sub_ref "A 13.5"
          conditional :has_parent_company, "yes"
          conditional :parent_ultimate_control, :no
        end

        options :trading_figures, "Do you have any UK subsidiaries, associates or plants whose trading figures are included in this entry?" do
          ref "A 14"
          required
          yes_no
        end

        subsidiaries_associates_plants :trading_figures_add, "For each of the UK subsidiaries included in this application enter: 1. name, 2. location, 3. number of UK employees (FTE - full-time equivalent), 4. the reason why you are including them." do
          required
          classes "sub-question"
          sub_ref "A 14.1"
          pdf_title "For each of the UK subsidiaries included in this application enter: 1. name, 2. location, 3. number of UK employees (FTE - full-time equivalent), 4. the reason why you are including them."
          conditional :trading_figures, :yes
          details_words_max 100
        end

        options :export_agent, "Are you an export agent/merchant/wholesaler?" do
          ref "A 15"
          required
          yes_no
          form_hint "An export agent exports goods/services on behalf of another company in exchange for a commission. An export merchant buys merchandise to sell on at a higher price (sometimes rebranding/repacking in the process)."
        end

        options :export_unit, "Are you an export unit?" do
          ref "A 16"
          required
          yes_no
          help "What is an export unit?", %(
            <p class='govuk-hint'>An export unit is a subsidiary or operating unit of a larger company that manages the company's export activities.</p>
          )
        end

        upload :org_chart, "Upload an organisational chart." do
          ref "A 17"
          context %(
            <p class='govuk-hint'>You can submit a file in any common format, as long as it is less than 5mb.</p>
          )
          hint "What are the allowed file formats?", %(
            <p class='govuk-hint'>
              You can upload any of the following file formats: chm, csv, diff, doc, docx, dot, dxf, eps, gif, gml, ics, jpg, kml, odp, ods, odt, pdf, png, ppt, pptx, ps, rdf, rtf, sch, txt, wsdl, xls, xlsm, xlsx, xlt, xml, xsd, xslt, zip.
            </p>
          )
          max_attachments 1
        end

        checkbox_seria :how_did_you_hear_about_award, "How did you hear about the King’s Awards for Enterprise award this year?" do
          ref "A 18"
          required
          form_hint "Select all that apply."
          check_options [
            ["qa_website", "King's Awards website"],
            ["qa_twitter", "King's Awards Twitter"],
            ["social_media", "Other social media"],
            ["another_website", "Another website"],
            ["qa_event", "King's Awards event"],
            ["another_event", "A third party exhibition or event"],
            ["publication", "A newspaper/publication"],
            ["word_of_mouth", "Word of mouth"],
            ["other", "Other"]
          ]
        end
      end
    end
  end
end
