# coding: utf-8
class AwardYears::V2024::QAEForms
  class << self
    def development_step2
      @development_step2 ||= proc do
        header :company_information_header, "" do
          section_info
          context %(
            <h3 class='govuk-heading-m'>About section B</h3>
            <p class='govuk-body'>
              The purpose of this section is to collect specific information that identifies your organisation, for example, your registration number and address. It is important that the details provided are accurate as they cannot be changed after the submission deadline.
            </p>
            <p class='govuk-body'>
              This information will also be used to enable us to undertake due diligence checks with other government departments and agencies if your application is shortlisted. Please be aware due diligence checks inform the decision to confer an award.
            </p>
            <h3 class="govuk-heading-m">Small organisations</h3>
            <p class="govuk-body">
              King's Awards for Enterprise is committed to acknowledging the efforts of organisations of all sizes. When assessing we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all questions to the degree you can.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "About section B"],
            [:normal, %(
              The purpose of this section is to collect specific information that identifies your organisation, for example, your registration number and address. It is important that the details provided are accurate as they cannot be changed after the submission deadline.

              This information will also be used to enable us to undertake due diligence checks with other government departments and agencies if your application is shortlisted. Please be aware due diligence checks inform the decision to confer an award.
            )],
            [:bold, "Small organisations"],
            [:normal, %(
              King's Awards for Enterprise is committed to acknowledging the efforts of organisations of all sizes. When assessing we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all questions to the degree you can.
            )]
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

        text :company_name, "Full/legal name of your organisation" do
          required
          ref "B 2"
          context %(
            <p>If applicable, include 'trading as', or any other name your organisation uses. Please note, if successful, we will use this name on any award materials - for example, award certificates.</p>
          )
        end

        text :brand_name, "Organisation name as you would like it to appear on award certificate and announcements." do
          classes "sub-question"
          sub_ref "B 2.1"
          required
          context %{
            <p>This may be the same as your organisation's full legal name. However, you may choose the name you are trading as or your brand name.</p>
            <p>If you ask us to use an alternative name for these purposes, the evidence provided in the form must be clearly linked to it.</p>
          }
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
          classes "sub-question"
          sub_ref "B 3.1"
          required
          conditional :principal_business, :no
          words_max 100
          rows 5
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

        text :registration_number, "Provide your company or charity registration number or, if not registered, explain why." do
          classes "sub-question"
          required
          ref "B 4.1"
          context %(
            <p>If you're an unregistered subsidiary, please enter your parent company's number.</p>
          )
          style "small"
        end

        text :vat_registration_number, "Provide your VAT registration number or, if not registered, explain why." do
          classes "sub-question"
          required
          ref "B 4.2"
          context %(
            <p>If you're an unregistered subsidiary, please enter your parent company's VAT number.</p>
          )
          style "small"
        end

        date :started_trading, "Date started trading" do
          required
          ref "B 5"
          context -> do
            %(
              <p>
                Organisations that began trading after #{AwardYear.start_trading_since(2)} aren't eligible for this award.
              </p>
            )
          end

          date_max AwardYear.start_trading_since(2)
        end

        options :applied_for_queen_awards, "In the last ten years have you applied, whether you have won or not, for a Queen’s Awards for Enterprise award in any category?" do
          required
          ref "B 6"
          yes_no
          classes "queen-award-holder"
        end

        queen_award_applications :applied_for_queen_awards_details, "List the Queen’s awards you have applied for in the last 10 years." do
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
        end

        options_business_name_changed :business_name_changed, "Have you changed the name of your organisation since your last entry?" do
          classes "sub-question"
          sub_ref "B 6.2"
          required
          conditional :applied_for_queen_awards, :yes
          yes_no
        end

        text :previous_business_name, "Name used previously" do
          classes "sub-question"
          sub_ref "B 6.3"
          required
          conditional :business_name_changed, :yes
          conditional :applied_for_queen_awards, :yes
        end

        textarea :previous_business_ref_num, "Reference number(s) used previously" do
          classes "sub-question"
          sub_ref "B 6.4"
          required
          conditional :business_name_changed, :yes
          conditional :applied_for_queen_awards, :yes
          rows 5
          words_max 100
        end

        options :other_awards_won, "Have you won any other awards in the past?" do
          ref "B 7"
          required
          yes_no
        end

        textarea :other_awards_desc, "Describe the awards you have won in the past." do
          classes "sub-question"
          sub_ref "B 7.1"
          required
          context %(
            <p>
              If you can't fit all of your awards below, then choose those you're most proud of.
            </p>
                    )
          conditional :other_awards_won, :yes
          rows 5
          words_max 250
        end

        options :part_of_joint_entry, "Is this application part of a joint entry with any contributing organisation?" do
          ref "B 8"
          required
          context %(
            <p>
              If two or more organisations made a significant contribution to the product, service or management approach, then you should make a joint entry. Each organisation should submit separate, cross-referenced, entry forms.
            </p>
          )
          yes_no
        end

        textarea :part_of_joint_entry_names, "Please enter their name(s)." do
          classes "sub-question"
          sub_ref "B 8.1"
          required
          conditional :part_of_joint_entry, "yes"
          words_max 100
          rows 2
        end

        options :external_contribute_to_sustainable_product,
                "Did any external organisation(s) or individual(s) contribute to your sustainable product/service/management approach?" do
          ref "B 9"
          required
          context %(
            <p>
              <strong>Excluding</strong> paid suppliers and consultants.
            </p>
                    )
          yes_no
        end

        options :external_are_aware_about_award,
                "Are they aware that you're applying for this award?" do
          classes "sub-question"
          sub_ref "B 9.1"
          required
          option "yes", "Yes, they are all aware"
          option "no", "No, they are not all aware"
          conditional :external_contribute_to_sustainable_product, "yes"
        end

        header :external_organization_or_individual_info_header_no, "" do
          classes "application-notice help-notice"
          context %(
            <p class="govuk-body">
              We recommend that you notify all the contributors to your product/service/management approach of this entry.
            </p>
          )
          conditional :external_contribute_to_sustainable_product, "yes"
          conditional :external_are_aware_about_award, "no"
        end

        textarea :why_external_organisations_contributed_your_nomination, "Explain why external organisations or individuals that contributed to your sustainable development are not all aware of this applications." do
          classes "sub-question"
          sub_ref "B 9.2"
          required
          words_max 200
          conditional :external_contribute_to_sustainable_product, "yes"
          conditional :external_are_aware_about_award, "no"
          rows 3
        end

        address :organization_address, "Trading address of your organisation" do
          required
          ref "B 10"
          pdf_context_with_header_blocks [
            [:normal, "Please double-check the county using the GOV.UK tool: https://www.gov.uk/find-local-council"]
          ]
          county_context %(
            <p class='govuk-hint'>Please double-check the county using the GOV.UK tool: https://www.gov.uk/find-local-council</p>
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
          ref "B 10.1"
          type "tel"
          style "small"
        end

        press_contact_details :press_contact_details, "Contact details for press enquiries" do
          ref "B 11"
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
          ref "B 12"
          style "large"
          form_hint "Please provide full website address, for example, www.yourcompanyname.com"
        end

        textarea :social_media_links, "Links to social media accounts, for example, LinkedIn, Twitter, Instagram." do
          classes "sub-question"
          sub_ref "B 12.1"
          context %{
            <p>Please note, when evaluating your application, the assessors may check your organisation's online presence.</p>
          }
        end

        sic_code_dropdown :sic_code, "The Standard Industrial Classification (SIC) code" do
          required
          ref "B 13"
          context %{
            <p>The Standard Industrial Classification (SIC) is a system for classifying industries. You can find more information about SIC at https://resources.companieshouse.gov.uk/sic/</p>
            <p>Select the first four digits of the SIC code that best represents the current activities of your business.</p>
          }
        end

        options :parent_or_a_holding_company, "Do you have a parent or a holding company?" do
          required
          ref "B 14"
          yes_no
        end

        text :parent_company, "Name of the immediate parent company" do
          required
          classes "sub-question"
          sub_ref "B 14.1"
          conditional :parent_or_a_holding_company, :yes
        end

        country :parent_company_country, "Country of immediate parent company" do
          classes "sub-question"
          required
          sub_ref "B 14.2"
          conditional :parent_or_a_holding_company, :yes
        end

        options :parent_ultimate_control, "Does your immediate parent company have ultimate control?" do
          required
          classes "sub-question"
          sub_ref "B 14.3"
          yes_no
          conditional :parent_or_a_holding_company, :yes
        end

        text :ultimate_control_company, "Name of organisation with ultimate control" do
          required
          classes "sub-question"
          sub_ref "B 14.4"
          conditional :parent_ultimate_control, :no
          conditional :parent_or_a_holding_company, :yes
        end

        country :ultimate_control_company_country, "Country of organisation with ultimate control" do
          classes "sub-question"
          sub_ref "B 14.5"
          conditional :parent_ultimate_control, :no
          conditional :parent_or_a_holding_company, :yes
        end

        upload :org_chart, "Upload an organisational chart (optional)" do
          ref "B 15"
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

        checkbox_seria :how_did_you_hear_about_award, "How did you hear about the Queen’s Awards for Enterprise award this year?" do
          ref "B 16"
          required
          context %(
            <p>Select all that apply.</p>
          )
          check_options [
            ["qa_website", "Queen's Awards website"],
            ["qa_twitter", "Queen's Awards Twitter"],
            ["social_media", "Other social media"],
            ["another_website", "Another website"],
            ["qa_event", "Queen's Awards event"],
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
