class AwardYears::V2018::QaeForms
  class << self
    def innovation_step1
      @innovation_step1 ||= proc do
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
              Where we refer to 'your organisation' in the form, please enter the details of your division, branch or subsidiary.
            </p>
          )
          conditional :applying_for, "division branch subsidiary"
        end

        text :company_name, "Full/legal name of your organisation" do
          required
          ref "A 2"
          context %(
            <p>If applicable, include 'trading as', or any other name your organisation uses/has used. Please note, if successful, we will use this name on any award materials - e.g. award certificates.</p>
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

        textarea :invoicing_unit_relations, "Please explain your relationship with the invoicing unit, and the arrangements made" do
          classes "sub-question"
          sub_ref "A 3.1"
          required
          conditional :principal_business, :no
          words_max 100
          rows 5
        end

        options :organisation_type, "Are you a company or charity?" do
          required
          ref "A 4"
          option "company", "Company"
          option "charity", "Charity"
        end

        text :registration_number, "Please provide your company or charity registration number or enter 'N/A'" do
          required
          ref "A 4.1"
          context %(
            <p>If you're an unregistered subsidiary, please enter your parent company's number.</p>
          )
          style "small"
        end

        text :vat_registration_number, "Please provide your VAT registration number or enter 'N/A'" do
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
                Organisations that began trading after #{AwardYear.start_trading_since(2)} aren't eligible for this award (or #{AwardYear.start_trading_since(5)} if you are applying for the five-year award).
              </p>
            )
          end

          dynamic_date_max(
            dates: {
              "2 to 4" => AwardYear.start_trading_since(2),
              "5 plus" => AwardYear.start_trading_since(5),
            },
            conditional: :innovation_performance_years,
          )
        end

        options :queen_award_holder, -> { "Are you a current Queen's Award holder from #{AwardYear.award_holder_range}?" } do
          required
          ref "A 6"
          context -> do
            %(
              <p>If you have received a Queen's Award in any category between #{AwardYear.current.year - 5} and #{AwardYear.current.year - 1}, you are deemed a current award holder.</p>
            )
          end
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
          context "<p>If you can't fit all of your awards below, then choose those you're most proud of.</p>"
          conditional :other_awards_won, :yes
          rows 5
          words_max 250
        end

        options :innovation_joint_contributors, "Is this application part of a joint entry with any contributing organisation(s)?" do
          ref "A 8"
          required
          context %(
            <p>
              If two or more organisations made a significant contribution to the product, service or business model then you should make a joint entry. Each organisation should submit separate, cross-referenced, entry forms.
            </p>
          )
          yes_no
        end

        textarea :innovation_contributors, "Please enter their name(s)" do
          classes "sub-question"
          sub_ref "A 8.1"
          conditional :innovation_joint_contributors, :yes
          rows 2
          words_max 100
        end

        options :innovation_any_contributors, "Did any external organisation(s) or individual(s) contribute to your innovation?" do
          ref "A 9"
          required
          yes_no
        end

        options :innovation_contributors_aware, "Are they aware that you're applying for this award?" do
          classes "sub-question"
          sub_ref "A 9.1"
          required
          conditional :innovation_any_contributors, :yes
          option :yes, "Yes, they are all aware"
          option :no, "No, they are not all aware"
        end

        header :innovation_contributors_aware_header_no, "" do
          classes "application-notice help-notice"
          context %(
            <p>We recommend that you notify all the contributors to your innovation of this entry.</p>
          )
          conditional :innovation_any_contributors, :yes
          conditional :innovation_contributors_aware, :no
        end

        textarea :innovation_contributors_why_organisations, "Explain why external organisations or individuals that contributed to your innovation are not all aware of this applications" do
          classes "sub-question"
          sub_ref "A 9.2"
          required
          conditional :innovation_any_contributors, :yes
          conditional :innovation_contributors_aware, :no
          rows 3
          words_max 200
        end

        options :innovation_under_license, "Is your innovation under licence from another organisation?" do
          ref "A 10"
          yes_no
        end

        textarea :innovation_license_terms, "Briefly describe the licensing arrangement" do
          classes "sub-question"
          sub_ref "A 10.1"
          required
          conditional :innovation_under_license, :yes
          rows 5
          words_max 100
        end

        address :organization_address, "Trading address of your organisation" do
          required
          ref "A 11"
          sub_fields([
            { building: "Building" },
            { street: "Street" },
            { city: "Town or city" },
            { county: "County" },
            { postcode: "Postcode" },
            { region: "Region" },
          ])
        end

        text :org_telephone, "Main telephone number" do
          required
          ref "A 12"
          style "small"
        end

        text :website_url, "Website address" do
          ref "A 13"
          style "large"
          form_hint "e.g. www.example.com"
        end

        sic_code_dropdown :sic_code, "SIC code" do
          required
          ref "A 14"
        end

        options :has_parent_company, "Do you have a parent or a holding company?" do
          ref "A 15"
          yes_no
          required
        end

        text :parent_company, "Name of immediate parent company" do
          sub_ref "A 15.1"
          classes "sub-question"
          conditional :has_parent_company, "yes"
        end

        country :parent_company_country, "Country of immediate parent company" do
          sub_ref "A 15.2"
          classes "regular-question"
          conditional :has_parent_company, "yes"
        end

        options :parent_ultimate_control, "Does your immediate parent company have ultimate control?" do
          sub_ref "A 15.3"
          classes "sub-question"
          conditional :has_parent_company, "yes"
          yes_no
        end

        text :ultimate_control_company, "Name of organisation with ultimate control" do
          classes "regular-question"
          sub_ref "A 15.4"
          conditional :parent_ultimate_control, :no
          conditional :has_parent_company, "yes"
        end

        country :ultimate_control_company_country, "Country of organisation with ultimate control" do
          classes "regular-question"
          sub_ref "A 15.5"
          conditional :parent_ultimate_control, :no
          conditional :has_parent_company, "yes"
        end

        upload :org_chart, "Upload an organisational chart (optional)" do
          ref "A 16"
          context %(
            <p>You can submit a file in any common format, as long as it is less than 5mb.</p>
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
