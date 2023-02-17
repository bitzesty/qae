# coding: utf-8
class AwardYears::V2024::QAEForms
  class << self
    def mobility_step2
      @mobility_step2 ||= proc do
        header :company_information_header, "" do
          section_info
          context %(
            <h3 class='govuk-heading-m'>About section B</h3>
            <p class='govuk-body'>
              The purpose of this section is to collect specific information that identifies your organisation, for example, your registration number and address. It is important that the details are accurate as they cannot be changed after the submission deadline.
            </p>
            <p class='govuk-body'>
              This information will also be used to enable The King's Awards Office to undertake due diligence checks with other government departments and agencies if your application is shortlisted. Please be aware due diligence checks inform the decision to confer an award.
            </p>
            <h3 class="govuk-heading-m">Small organisations</h3>
            <p class="govuk-body">
              King's Awards for Enterprise is committed to acknowledging the efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all questions to the degree you can.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "About section B"],
            [:normal, %(
              The purpose of this section is to collect specific information that identifies your organisation, for example, your registration number and address. It is important that the details are accurate as they cannot be changed after the submission deadline.

              This information will also be used to enable The King's Awards Office to undertake due diligence checks with other government departments and agencies if your application is shortlisted. Please be aware due diligence checks inform the decision to confer an award.
            )],
            [:bold, "Small organisations"],
            [:normal, %(
                King's Awards for Enterprise is committed to acknowledging the efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all questions to the degree you can.
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
              Where we refer to 'your organisation' in the form, please enter the details of your division, branch or subsidiary.
            </p>
          )
          conditional :applying_for, "division branch subsidiary"
        end

        text :company_name, "Full legal name of your organisation" do
          required
          ref "B 2"
          context %(
            <p>If your organisation is a company or charity, please make sure that the name provided is in line with the company or charity registration number.</p>
          )
        end

        text :brand_name, "Organisation name as you would like it to appear on award certificate and announcements." do
          sub_ref "B 2.1"
          classes "sub-question"
          required
          context %(
            <p>Usually, this is the same name as your organisation's full legal name.</p>
            <p>However, you may choose to include the name you are trading as or a brand name. If you do so, you may be asked to provide evidence that the legal entity uses the trading name or owns the brand. Also, the evidence in the application form must be clearly linked to the provided trading name or brand.</p>
          )
        end

        options :principal_business, "Does your organisation operate as a principal?" do
          required
          ref "B 3"
          context %(
            <p>
              We recommend that you apply as a principal. A principal invoices its customers (or their buying agents) and is the body to receive those payments.
            </p>
          )
          yes_no
        end

        textarea :invoicing_unit_relations, "Please explain your relationship with the invoicing unit, and the arrangements made." do
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
          option "limited_company", "Limited Company (Ltd)"
          option "public_limited_company", "Public Limited Company (Plc)"
          option "community_interest_company", "Community Interest Company (CIC)"
          option "charity", "Charity"
          option "other", "Other"
        end

        text :other_organisation_type, "Please specify" do
          classes "other-organization-type"
          required
          conditional :organisation_type, "other"
        end

        textarea :registration_number, "Provide your company or charity registration number or, if not registered, explain why." do
          classes "sub-question word-max-strict"
          required
          ref "B 4.1"
          context %(
            <p>If you're an unregistered subsidiary, please enter your parent company's number.</p>
          )
          words_max 50
        end

        text :vat_registration_number, "Please provide your VAT registration number or enter 'N/A'." do
          classes "sub-question"
          required
          ref "A 4.2"
          context %(
            <p>If you're an unregistered subsidiary, please enter your parent company's number.</p>
                    )
          style "small"
        end

        date :started_trading, "Date started trading" do
          required
          ref "A 5"
          context -> do
            %(
              <p>
                 Organisations that began trading after #{AwardYear.start_trading_since(2)} aren't eligible for this award.
              </p>
            )
          end
          date_max AwardYear.start_trading_since(2)
        end

        options :applied_for_queen_awards, "In the last ten years have you applied, whether you have won or not, for a King’s Awards for Enterprise award in any category?" do
          required
          ref "A 6"
          yes_no
          classes "queen-award-holder"
        end

        queen_award_applications :applied_for_queen_awards_details, "List the King’s awards you have applied for in the last 10 years." do
          classes "sub-question question-current-awards"
          sub_ref "A 6.1"

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
        end

        options_business_name_changed :business_name_changed, "Have you changed the name of your organisation since your last entry?" do
          classes "sub-question"
          sub_ref "A 6.2"
          required
          conditional :applied_for_queen_awards, :yes
          yes_no
        end

        text :previous_business_name, "Name used previously" do
          classes "sub-question"
          sub_ref "A 6.3"
          required
          conditional :business_name_changed, :yes
          conditional :applied_for_queen_awards, :yes
        end

        options :other_awards_won, "Have you won any other awards in the past?" do
          ref "A 7"
          required
          yes_no
        end

        textarea :other_awards_desc, "Please describe them." do
          classes "sub-question"
          sub_ref "A 7.1"
          required
          context %(
            <p>
              If you can't fit all your awards below, then choose those you're most proud of.
            </p>
          )
          conditional :other_awards_won, :yes
          rows 5
          words_max 250
        end

        options :part_of_joint_entry,
                "Is this application part of a joint entry with any contributing organisation(s)?" do
          ref "A 8"
          required
          context %(
            <p>
              If two or more organisations made a significant contribution to the social mobility programme, then you should make a joint entry.
            </p>
            <p>
              Each organisation should submit separate, cross-referenced, entry forms.
            </p>
          )
          yes_no
        end

        textarea :part_of_joint_entry_names, "Please enter their name(s)." do
          classes "sub-question"
          sub_ref "A 8.1"
          required
          conditional :part_of_joint_entry, "yes"
          words_max 100
          rows 2
        end

        options :external_contribute_to_sustainable_product, "Did any external organisation(s) or individual(s) contribute to your social mobility programme?" do
          ref "A 9"
          required
          context %(
            <p>
              <strong>Excluding</strong> paid suppliers and consultants.
            </p>
          )
          yes_no
        end

        textarea :external_specify_organisations_contributions, "Specify the organisations that have contributed as well as what they contributed, including how and when." do
          sub_ref "A 9.1"
          required
          classes "sub-question"
          words_max 100
          rows 5
          conditional :external_contribute_to_sustainable_product, "yes"
        end

        options :external_are_aware_about_award,
                "Are they aware that you're applying for this award?" do
          sub_ref "A 9.2"
          classes "sub-question"
          required
          option "yes", "Yes, they are all aware"
          option "no", "No, they are not all aware"
          conditional :external_contribute_to_sustainable_product, "yes"
        end

        header :external_organization_or_individual_info_header_no, "" do
          classes "application-notice help-notice"
          context %(
            <p class="govuk-body">
              We recommend that you notify all the contributors to your social mobility programme relating to this entry.
            </p>
          )
          conditional :external_contribute_to_sustainable_product, "yes"
          conditional :external_are_aware_about_award, "no"
        end

        textarea :why_external_organisations_contributed_your_nomination, "Explain why external organisations or individuals that contributed to your innovation are not all aware of this application." do
          classes "sub-question"
          sub_ref "A 9.3"
          required
          words_max 200
          conditional :external_contribute_to_sustainable_product, "yes"
          conditional :external_are_aware_about_award, "no"
          rows 3
        end

        address :organization_address, "Trading address of your organisation" do
          required
          ref "A 10"
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
          ref "A 10.1"
          type "tel"
          style "small"
        end

        press_contact_details :press_contact_details, "Contact details for press enquiries" do
          ref "A 11"
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
          ref "A 12"
          style "large"
          form_hint "Please provide full website address, for example, www.yourcompanyname.com"
        end

        sic_code_dropdown :sic_code, "The Standard Industrial Classification (SIC) code" do
          required
          ref "A 13"
          context %(
            <p>
              The Standard Industrial Classification (SIC) is a system for classifying industries. If you are a registered company, this is the same code you would have provided Companies House.
            </p>
          )
        end

        options :parent_or_a_holding_company, "Do you have a parent or a holding company?" do
          required
          ref "A 14"
          yes_no
        end

        text :parent_company, "Name of immediate parent company" do
          required
          classes "sub-question"
          sub_ref "A 14.1"
          conditional :parent_or_a_holding_company, :yes
        end

        country :parent_company_country, "Country of immediate parent company" do
          required
          classes "sub-question"
          sub_ref "A 14.2"
          conditional :parent_or_a_holding_company, :yes
        end

        options :parent_ultimate_control, "Does your immediate parent company have ultimate control?" do
          required
          classes "sub-question"
          sub_ref "A 14.3"
          yes_no
          conditional :parent_or_a_holding_company, :yes
        end

        text :ultimate_control_company, "Name of organisation with ultimate control" do
          required
          classes "sub-question"
          sub_ref "A 14.4"
          conditional :parent_ultimate_control, :no
          conditional :parent_or_a_holding_company, :yes
        end

        country :ultimate_control_company_country, "Country of organisation with ultimate control" do
          classes "sub-question"
          sub_ref "A 14.5"
          conditional :parent_ultimate_control, :no
          conditional :parent_or_a_holding_company, :yes
        end

        upload :org_chart, "Upload an organisational chart (optional)." do
          ref "A 15"
          context %(
            <p>You can submit a file in any common format, as long as it is less than 5mb.</p>
          )
          hint "What are the allowed file formats?", %(
            <p>
              You can upload any of the following file formats: chm, csv, diff, doc, docx, dot, dxf, eps, gif, gml, ics, jpg, kml, odp, ods, odt, pdf, png, ppt, pptx, ps, rdf, rtf, sch, txt, wsdl, xls, xlsm, xlsx, xlt, xml, xsd, xslt, zip.
            </p>
          )
          max_attachments 1
        end

        checkbox_seria :how_did_you_hear_about_award, "How did you hear about the King’s Awards for Enterprise award this year?" do
          ref "A 16"
          required
          context %(
            <p>Select all that apply.</p>
          )
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
