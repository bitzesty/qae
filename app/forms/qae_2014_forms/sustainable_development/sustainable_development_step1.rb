class QAE2014Forms
  class << self
    def development_step1
      @development_step1 ||= proc do
        header :company_information_header, "" do
          context %(
            <p>
              We need this information to ensure we have some basic information about your organisation, which will help us to undertake due diligence checks if your application is shortlisted.
            </p>
          )
        end

        options :applying_for, "Are you applying on behalf of your:" do
          ref "A 1"
          required
          option "organisation", "Whole organisation (with ultimate control)"
          option "division branch subsidiary", "A division, branch or subsidiary"
        end

        header :business_division_header, "" do
          classes "application-notice help-notice"
          context %(
            <p>
              Where the form refers to your organisation,
              please enter the details of your division, branch or subsidiary.
            </p>
          )
          conditional :applying_for, "division branch subsidiary"
        end

        text :company_name, "Full/legal name of your organisation" do
          required
          ref "A 2"
          context %(
            <p>If applicable, include 'trading as', or any other name your organisation uses.  Please note, if successful, we will use this name on any award materials - e.g. award certificates.</p>
          )
        end

        options :principal_business, "Does your organisation operate as a principal?" do
          required
          ref "A 3"
          context %(
            <p>
              We recommend that you apply as a principal. A principal invoices its customers (or their buying agents) and is the body to receive those payments.
            </p>
          )
          yes_no
        end

        textarea :invoicing_unit_relations, "Please explain your relationship with the invoicing unit, and the arrangements made." do
          classes "sub-question"
          sub_ref "A 3.1"
          required
          conditional :principal_business, :no
          words_max 200
          rows 5
        end

        options :organisation_type, "Are you a company or charity?" do
          required
          ref "A 4"
          option "company", "Company"
          option "charity", "Charity"
        end

        text :registration_number, "Please provide your company or charity registration number or enter 'N/A'." do
          required
          ref "A 4.1"
          context %(
            <p>If you're an unregistered subsidiary, please enter your parent company's number.</p>
                    )
          style "small"
        end

        text :vat_registration_number, "Please provide your VAT registration number or enter 'N/A'." do
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
          context %(
            <p>
               Organisations that began trading after #{AwardYear.start_trading_since(2)} aren't eligible for this award (or #{AwardYear.start_trading_since(5)} if you are applying for the five-year award).
            </p>
          )
          date_max AwardYear.start_trading_since(2)
        end

        options :queen_award_holder, "Are you a current Queen's Award holder (#{AwardYear.award_holder_range})?" do
          required
          ref "A 6"
          yes_no
          option "i_dont_know", "I don't know"
          classes "queen-award-holder"
        end

        queen_award_holder :queen_award_holder_details, "List The Queen's Award(s) you currently hold" do
          classes "sub-question question-current-awards"
          sub_ref "A 6.1"

          conditional :queen_award_holder, :yes

          category :innovation, "Innovation"
          category :international_trade, "International Trade"
          category :sustainable_development, "Sustainable Development"

          ((AwardYear.current.year - 5)..(AwardYear.current.year - 1)).each do |y|
            year y
          end
        end

        options_business_name_changed :business_name_changed, "Have you changed the name of your organisation since your last entry?" do
          classes "sub-question"
          sub_ref "A 6.2"
          required
          conditional :queen_award_holder, :yes
          yes_no
        end

        text :previous_business_name, "Name used previously" do
          classes "regular-question"
          sub_ref "A 6.3"
          required
          conditional :business_name_changed, :yes
          conditional :queen_award_holder, :yes
        end

        textarea :previous_business_ref_num, "Reference number(s) used previously" do
          classes "regular-question"
          sub_ref "A 6.4"
          required
          conditional :business_name_changed, :yes
          conditional :queen_award_holder, :yes
          rows 5
          words_max 100
        end

        options :other_awards_won, "Have you won any other awards in the past?" do
          ref "A 7"
          required
          yes_no
        end

        textarea :other_awards_desc, "Please describe them" do
          classes "sub-question"
          sub_ref "A 7.1"
          required
          context %(
            <p>
              If you can't fit all of your awards below, then choose those you're most proud of.
            </p>
                    )
          conditional :other_awards_won, :yes
          rows 5
          words_max 300
        end

        options :part_of_joint_entry,
                "Is this application part of a joint entry with any of the contributing organisation(s)?" do
          ref "A 8"
          required
          context %(
            <p>
              If two or more organisations made a significant contribution to the product,
              service or management approach then you should make a joint entry.
              Each organisation should submit separate, cross-referenced, entry forms.
            </p>
          )
          yes_no
        end

        textarea :part_of_joint_entry_names, "Please enter their name(s)" do
          sub_ref "A 8.1"
          required
          conditional :part_of_joint_entry, "yes"
          words_max 100
          rows 2
        end

        options :external_contribute_to_sustainable_product,
                "Did any external organisation(s) or individual(s) contribute to your sustainable product/service/management approach?" do
          ref "A 9"
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
          sub_ref "A 9.1"
          required
          option "yes", "Yes, they are all aware"
          option "no", "No, they are not all aware"
          conditional :external_contribute_to_sustainable_product, "yes"
        end

        header :external_organization_or_individual_info_header_no, "" do
          classes "application-notice help-notice"
          context %(
            <p>
              We recommend that you notify all the contributors to your product/service/management approach of this entry.
            </p>
          )
          conditional :external_contribute_to_sustainable_product, "yes"
          conditional :external_are_aware_about_award, "no"
        end

        textarea :why_external_organisations_contributed_your_nomination, "Explain why external organisations or individuals that contributed to your sustainable development are not all aware of this applications." do
          sub_ref "A 9.2"
          required
          words_max 200
          conditional :external_contribute_to_sustainable_product, "yes"
          conditional :external_are_aware_about_award, "no"
          rows 3
        end

        address :organization_address, "Trading address of your organisation" do
          required
          ref "A 10"
          sub_fields([
            { building: "Building" },
            { street: "Street" },
            { city: "Town or city" },
            { county: "County" },
            { postcode: "Postcode" },
            { region: "Region" }
          ])
        end

        text :org_telephone, "Main telephone number" do
          required
          ref "A 11"
          style "small"
        end

        text :website_url, "Website Address" do
          ref "A 12"
          style "large"
          form_hint "e.g. www.example.com"
        end

        sic_code_dropdown :sic_code, "SIC code" do
          required
          ref "A 13"
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
          classes "regular-question"
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
          classes "regular-question"
          sub_ref "A 14.4"
          conditional :parent_ultimate_control, :no
          conditional :parent_or_a_holding_company, :yes
        end

        country :ultimate_control_company_country, "Country of organisation with ultimate control" do
          classes "regular-question"
          sub_ref "A 14.5"
          conditional :parent_ultimate_control, :yes
          conditional :parent_or_a_holding_company, :yes
        end

        upload :org_chart, "Upload an organisational chart (optional)" do
          ref "A 15"
          context %(
            <p>You can submit files in all common formats, as long as they're less than 5mb each.</p>
                    )
          hint "What are the allowed file formats?", %(
            <p>
              You can upload any of the following file formats:
            </p>
            <p>
              chm, csv, diff, doc, docx, dot, dxf, eps, gif, gml, ics, jpg, kml, odp, ods, odt, pdf, png, ppt, pptx, ps, rdf, rtf, sch, txt, wsdl, xls, xlsm, xlsx, xlt, xml, xsd, xslt, zip
            </p>
          )
          max_attachments 1
        end
      end
    end
  end
end
