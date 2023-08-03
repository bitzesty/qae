# coding: utf-8
class AwardYears::V2024::QAEForms
  class << self
    def trade_step2
      @trade_step2 ||= proc do
        about_section :company_information_header, "" do
          section "company_information"
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
              Where we refer to 'your organisation' in the form, enter the details of your division, branch or subsidiary.
            </p>
          )
          conditional :applying_for, "division branch subsidiary"
        end

        options :principal_business, "Does your organisation operate as a principal?" do
          required
          ref "B 2"
          context %(
            <p class="govuk-hint">
              We recommend that you apply as a principal. A principal invoices its customers (or their buying agents) and is the body to receive those payments.
            </p>
          )
          yes_no
        end

        textarea :invoicing_unit_relations, "Explain your relationship with the invoicing unit, and the arrangements made." do
          classes "sub-question word-max-strict"
          sub_ref "B 2.1"
          required
          conditional :principal_business, :no
          words_max 100
          rows 1
        end

        options :organisation_type, "What type of legal entity is your organisation?" do
          required
          ref "B 3"
          context %(
            <p class="govuk-hint">
              All types of organisations are eligible to apply for The King's Award for Enterprise.
            </p>
          )
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
          ref "B 3.1"
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
          ref "B 3.2"
          context %(
            <p class="govuk-hint">If you're an unregistered subsidiary, enter your parent company's VAT number.</p>
          )
          style "small"
        end

        text :company_name, "Full legal name of your organisation." do
          required
          ref "B 4"
          context %(
            <p class="govuk-hint">
              If your organisation is a company or charity, please make sure that the name provided is in line with the company or charity registration number.
            </p>
          )
        end

        text :brand_name, "Organisation name as you would like it to appear on award certificate and announcements." do
          classes "sub-question"
          sub_ref "B 4.1"
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

        date :started_trading, "Date started trading." do
          classes "js-started-trading date-DDMMYYYY"
          required
          ref "B 5"
          context %(
            <p class="govuk-hint">
              Organisations that began trading after #{AwardYear.start_trading_since(3)} aren't eligible for this award.
            </p>
          )
          date_max AwardYear.start_trading_since(3)
        end

        address :organization_address, "Trading address of your organisation." do
          required
          ref "B 6"
          pdf_context_with_header_blocks [
            [:normal, "Please double-check the county using the GOV.UK tool: https://www.gov.uk/find-local-council"]
          ]
          county_context %(
            <p class='govuk-hint'>Please double-check the county using the GOV.UK tool:
              <a class="govuk-link" target="_blank" href="https://www.gov.uk/find-local-council">https://www.gov.uk/find-local-council</a>
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

        text :org_telephone, "Main telephone number." do
          required
          ref "B 6.1"
          type "tel"
          style "small"
        end

        sub_fields :press_contact_details, "Contact details for press enquiries." do
          ref "B 7"
          required
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

        text :website_url, "Website address (optional)." do
          ref "B 8"
          style "large"
          context %(
            <p class="govuk-hint">
              Please provide the full website address, for example, www.yourcompanyname.com
            </p>
          )
        end

        text :social_media_links, "Links to social media accounts, for example, LinkedIn, Twitter, Instagram (optional)." do
          ref "B 8.1"
          style "large"
          context %(
            <p class="govuk-hint">
              Please note, when evaluating your application, the assessors may check your organisation's online presence.
            </p>
          )
        end

        sic_code_dropdown :sic_code, "The Standard Industrial Classification (SIC) code." do
          required
          ref "B 9"
          context %(
            <p class="govuk-hint">
              The Standard Industrial Classification (SIC) is a system for classifying industries. You can find more information about SIC at
              <a class="govuk-link" target="_blank" href="https://resources.companieshouse.gov.uk/sic/">https://resources.companieshouse.gov.uk/sic/</a>.
            </p>
            <p class="govuk-hint">
              Select the first four digits of the SIC code that best represents the current activities of your business.
            </p>
          )
          pdf_context_with_header_blocks [
            [:normal, "The Standard Industrial Classification (SIC) is a system for classifying industries. You can find more information about SIC at https://resources.companieshouse.gov.uk/sic/."],
            [:normal, "Select the first four digits of the SIC code that best represents the current activities of your business."]
          ]
        end

        options :parent_group_entry, "Are you a parent company making a group entry?" do
          ref "B 10"
          yes_no
          required
        end

        options :pareent_group_excluding, "Are you excluding any members of your group from this application?" do
          classes "sub-question"
          sub_ref "B 10.1"
          conditional :parent_group_entry, "yes"
          yes_no
          required
        end

        textarea :pareent_group_why_excluding_members, "Please explain why you are excluding any members of your group from this application." do
          classes "sub-question word-max-strict"
          sub_ref "B 10.2"
          rows 5
          words_max 100
          conditional :parent_group_entry, "yes"
          conditional :pareent_group_excluding, "yes"
          required
        end

        options :has_parent_company, "Do you have a parent or a holding company?" do
          ref "B 11"
          required
          yes_no
        end

        text :parent_company, "Name of the immediate parent company." do
          classes "sub-question"
          sub_ref "B 11.1"
          conditional :has_parent_company, "yes"
          required
        end

        country :parent_company_country, "Country of the immediate parent company." do
          classes "sub-question"
          sub_ref "B 11.2"
          required
          conditional :has_parent_company, "yes"
        end

        options :parent_ultimate_control, "Does your immediate parent company have ultimate control of your organisation?" do
          classes "sub-question"
          sub_ref "B 11.3"
          conditional :has_parent_company, "yes"
          yes_no
          required
        end

        text :ultimate_control_company, "The name of the organisation with ultimate control." do
          classes "regular-question"
          sub_ref "B 11.4"
          required
          conditional :parent_ultimate_control, :no
        end

        country :ultimate_control_company_country, "Country of organisation with ultimate control." do
          classes "regular-question"
          sub_ref "B 11.5"
          conditional :parent_ultimate_control, :no
          required
        end

        options :trading_figures, "Do you have any UK subsidiaries, associates or plants whose trading figures are included in this entry?" do
          ref "B 12"
          required
          yes_no
        end

        subsidiaries_associates_plants :trading_figures_add, "For each of the UK subsidiaries included in this application enter: 1. name, 2. location, 3. number of UK employees (FTE - full-time equivalent), 4. the reason why you are including them." do
          required
          classes "sub-question"
          sub_ref "B 12.1"
          pdf_title "For each of the UK subsidiaries included in this application enter: 1. name, 2. location, 3. number of UK employees (FTE - full-time equivalent), 4. the reason why you are including them."
          conditional :trading_figures, :yes
          details_words_max 100
        end

        options :export_agent, "Are you an export agent/merchant/wholesaler?" do
          ref "B 13"
          required
          yes_no
        end

        options :export_unit, "Are you an export unit?" do
          ref "B 14"
          required
          yes_no
          help "What is an export unit?", %(
            <p class='govuk-hint'>An export unit is a subsidiary or operating unit of a larger company that manages the company's export activities.</p>
          )
        end

        upload :org_chart, "Upload an organisational chart (optional)." do
          ref "B 15"
          context %(
            <p class='govuk-hint'>You can submit a file in most formats if it is less than five megabytes.</p>
          )
          hint "What are the accepted file formats?", %(
            <p class='govuk-hint'>
              You can upload any of the following file formats: chm, csv, diff, doc, docx, dot, dxf, eps, gif, gml, ics, jpg, kml, odp, ods, odt, pdf, png, ppt, pptx, ps, rdf, rtf, sch, txt, wsdl, xls, xlsm, xlsx, xlt, xml, xsd, xslt, zip.
            </p>
          )
          max_attachments 1
        end

        options :applied_for_queen_awards, "In the last ten years, have you applied for The Queen's/King's Awards for Enterprise in any category?" do
          required
          ref "B 16"
          classes "queen-award-holder"
          context %(
            <p class="govuk-hint">
              Please answer yes, even if you have not won any of the Queen's/King's Awards you have applied for.
            </p>
          )
          yes_no
        end

        queen_award_applications :applied_for_queen_awards_details, "List the King's/Queen's awards you have applied for in the last 10 years." do
          classes "sub-question question-current-awards"
          sub_ref "B 16.1"

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
          sub_ref "B 16.2"

          option "yes", "Yes"
          option "no", "No"
          conditional :applied_for_queen_awards, :yes
        end

        text :previous_business_name, "Name used previously." do
          classes "sub-question"
          sub_ref "B 16.3"
          required
          conditional :applied_for_queen_awards, :yes
          conditional :business_name_changed, :yes
        end

        options :other_awards_won, "Have you won any other awards in the past?" do
          ref "B 17"
          required
          yes_no
        end

        textarea :other_awards_desc, "List the awards you have won in the past." do
          classes "sub-question word-max-strict"
          sub_ref "B 17.1"
          required
          form_hint "If you can't fit all of your awards below, then choose those you're most proud of."
          conditional :other_awards_won, :yes
          rows 2
          words_max 150
        end

        checkbox_seria :how_did_you_hear_about_award, "How did you hear about the King's Awards for Enterprise this year?" do
          ref "B 18"
          required
          form_hint "Select all that apply."
          check_options [
            ["qa_website", "The King's Awards website"],
            ["qa_twitter", "The King's Awards Twitter"],
            ["social_media", "Other social media"],
            ["another_website", "Another website"],
            ["qa_event", "The King's Awards event"],
            ["another_event", "A third-party exhibition or event"],
            ["publication", "A newspaper or publication"],
            ["word_of_mouth", "Word of mouth"],
            ["other", "Other"]
          ]
        end
      end
    end
  end
end
