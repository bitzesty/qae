class QAE2014Forms
  class << self
    def innovation_step1
      @innovation_step1 ||= proc do
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
              Where the form refers to your organisation, please enter the details of your division, branch or subsidiary.
            </p>
          )
          conditional :applying_for, "division branch subsidiary"
        end

        text :company_name, "Full/legal name of your organisation" do
          required
          ref "A 2"
          context %(
            <p>If applicable, include 'trading as', or any other name your organisation uses.</p>
                    )
        end

        options :principal_business, "Does your organisation operate as a principal?" do
          required
          ref "A 3"
          context %{
            <p>
              We recommend that you apply as a principal. A principal invoices its customers (or their buying agents) and is the body to receive those payments.
            </p>
          }
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

        text :registration_number, "Company/Charity Registration Number" do
          required
          ref "A 4"
          context %(
            <p>If you don't have a Company/Charity Registration Number please enter 'N/A'. If you're an unregistered subsidiary, please enter your parent company's number.</p>
                    )
          style "small"
        end

        date :started_trading, "Date started trading" do
          required
          ref "A 5"
          context "<p>Organisations that began trading after #{AwardYear.start_trading_moment('innovation')} aren't eligible for this award.</p>"
          date_max AwardYear.start_trading_moment("innovation")
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

        options :other_awards_won, "Have you won any other business or enterprise awards in the past?" do
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
          words_max 300
        end

        options :innovation_any_contributors, "Did any external organisation(s) or individual(s) contribute to your innovation?" do
          ref "A 8"
          required
          # context %(
          #   <p>
          #     <strong>
          #       Excluding
          #     </strong>
          #     suppliers and consultants.
          #   </p>
          # )
          yes_no
        end

        options :innovation_contributors_aware, "Are they aware that you're applying for this award?" do
          classes "sub-question"
          sub_ref "A 8.1"
          required
          conditional :innovation_any_contributors, :yes
          conditional :innovation_joint_contributors, :no
          option :yes, "Yes, they are aware"
          option :no, "No, they aren't aware"
          option :some, "Some are aware"
        end

        header :innovation_contributors_aware_header_no, "" do
          classes "application-notice help-notice"
          context %(
            <p>We recommend that you notify all the contributors to your innovation of this entry.</p>
                    )
          conditional :innovation_any_contributors, :yes
          conditional :innovation_contributors_aware, :no
          conditional :innovation_joint_contributors, :no
        end

        header :innovation_contributors_aware_header_some, "" do
          classes "application-notice help-notice if-no-js-hide"
          context %(
            <p>We recommend that you notify all the contributors to your innovation of this entry.</p>
                    )
          conditional :innovation_any_contributors, :yes
          conditional :innovation_contributors_aware, :some
          conditional :innovation_joint_contributors, :no
        end

        options :innovation_joint_contributors, "Is this application part of a joint entry with any of the contributing organisation(s)?" do
          classes "sub-question"
          sub_ref "A 8.2"
          required
          context %(
            <p>
              If two or more organisations made a significant contribution to the product/service/management approach (e.g. the business marketing a product, providing a service, or using a technology is different from the unit which developed it) and they both achieved commercial success, then you can make a joint entry. Each organisation should submit separate, cross-referenced, entry forms.
            </p>
          )
          conditional :innovation_any_contributors, :yes
          yes_no
        end

        textarea :innovation_contributors, "Please enter their name(s)" do
          classes "sub-question"
          sub_ref "A 8.3"
          required
          conditional :innovation_any_contributors, :yes
          conditional :innovation_joint_contributors, :yes
          rows 5
          words_max 500
        end

        options :innovation_under_license, "Is your innovation under license from another organisation?" do
          ref "A 9"
          yes_no
        end

        textarea :innovation_license_terms, "Briefly describe the licensing arrangement." do
          classes "sub-question"
          sub_ref "A 9.1"
          required
          conditional :innovation_under_license, :yes
          rows 5
          words_max 100
        end

        address :organization_address, "Principal address of your organisation" do
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

        business_sector_dropdown :business_sector, "Business Sector" do
          required
          ref "A 13"
        end

        text :business_sector_other, "Please specify" do
          classes "regular-question"
          sub_ref "A 13.1"
          required
          conditional :business_sector, :other
        end

        header :parent_company_header, "Parent Companies" do
          ref "A 14"
          conditional :applying_for, "division branch subsidiary"
        end

        text :parent_company, "Name of immediate parent company" do
          sub_ref "A 14.1"
          classes "sub-question"
          conditional :applying_for, "division branch subsidiary"
        end

        country :parent_company_country, "Country of immediate parent company" do
          sub_ref "A 14.2"
          classes "regular-question"
          conditional :applying_for, "division branch subsidiary"
        end

        options :parent_ultimate_control, "Does your immediate parent company have ultimate control?" do
          sub_ref "A 14.3"
          classes "sub-question"
          conditional :applying_for, "division branch subsidiary"
          yes_no
        end

        text :ultimate_control_company, "Name of organisation with ultimate control" do
          classes "regular-question"
          sub_ref "A 14.4"
          conditional :parent_ultimate_control, :no
          conditional :applying_for, "division branch subsidiary"
        end

        country :ultimate_control_company_country, "Country of organisation with ultimate control" do
          classes "regular-question"
          sub_ref "A 14.5"
          conditional :parent_ultimate_control, :no
          conditional :applying_for, "division branch subsidiary"
        end

        upload :org_chart, "Upload an organisational chart." do
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
