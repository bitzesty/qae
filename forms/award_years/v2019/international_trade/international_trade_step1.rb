class AwardYears::V2019::QaeForms
  class << self
    def trade_step1
      @trade_step1 ||= proc do
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
              Where the form refers to your organisation, enter the details of your division, branch or subsidiary.
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
            <p>We recommend that you apply as a principal. A principal invoices its customers (or their buying agents) and is the body to receive those payments.</p>
          )
          yes_no
        end

        textarea :invoicing_unit_relations, "Explain your relationship with the invoicing unit, and the arrangements made." do
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

        text :registration_number, "Provide your company or charity registration number or enter 'N/A'." do
          required
          classes "sub-question"
          ref "A 4.1"
          context %(
            <p>If you're an unregistered subsidiary, enter your parent company's number.</p>
          )
          style "small"
        end

        text :vat_registration_number, "Provide your VAT registration number or enter 'N/A'." do
          required
          classes "sub-question"
          ref "A 4.2"
          context %(
            <p>If you're an unregistered subsidiary, enter your parent company's number.</p>
          )
          style "small"
        end

        date :started_trading, "Date started trading" do
          required
          ref "A 5"
          context -> do
            %(
              <p>
                Organisations that began trading after #{AwardYear.start_trading_since(3)} aren't eligible for this award (or #{AwardYear.start_trading_since(6)} if you are applying for the six-year award).
              </p>
            )
          end

          date_max AwardYear.start_trading_since(3)
        end

        options :applied_for_queen_awards, "In the last ten years have you applied, whether you have won or not, for a Queen’s Awards for Enterprise award in any category?" do
          required
          ref "A 6"
          yes_no
          classes "queen-award-holder"
        end

        queen_award_applications :applied_for_queen_awards_details, "List the Queen’s awards you have applied for in the last 10 years." do
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

          children_options_depends_on :category
          dependable_values [:international_trade]
        end

        options_business_name_changed :business_name_changed, "Have you changed the name of your organisation since your last entry?" do
          classes "sub-question"
          sub_ref "A 6.2"

          option "yes", "Yes"
          option "no", "No"
          conditional :applied_for_queen_awards, :yes
        end

        text :previous_business_name, "Name used previously" do
          classes "sub-question"
          sub_ref "A 6.3"
          required
          conditional :applied_for_queen_awards, :yes
          conditional :business_name_changed, :yes
        end

        textarea :previous_business_ref_num, "Provide your previous winning application reference number(s)." do
          classes "sub-question"
          sub_ref "A 6.4"
          required
          rows 5
          words_max 100
          conditional :applied_for_queen_awards, :yes
          conditional :business_name_changed, :yes
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
          context "<p>If you can't fit all of your awards below, then choose those you're most proud of.</p>"
          conditional :other_awards_won, :yes
          rows 5
          words_max 250
        end

        address :organization_address, "Trading address of your organisation" do
          required
          ref "A 8"
          region_context %(
            <p>
              Please check the region your district belongs to on <a href="https://www.gbmaps.com/downloadpostcodemap.htm" target="_blank">GBMaps website</a>.
            </p>
          )
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
          ref "A 9"
          style "small"
        end

        text :website_url, "Website address" do
          ref "A 10"
          style "large"
          form_hint "e.g. www.example.com"
        end

        sic_code_dropdown :sic_code, "SIC code" do
          required
          ref "A 11"
        end

        options :parent_group_entry, "Are you a parent company making a group entry?" do
          ref "A 12"
          context %(
            <p>A 'group entry' is when you are applying on behalf of multiple divisions/branches/subsidiaries under your control.</p>
          )
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

        subsidiaries_associates_plants :trading_figures_add, "Enter the name, location and amount of UK employees (FTE - full-time equivalent) for each of the UK subsidiaries included in this application and the reason why you are including them." do
          required
          classes "sub-question"
          sub_ref "A 14.1"
          pdf_title "Enter the name, location and amount of UK employees (FTE - full time equivalent) for each of the UK subsidiaries included in this application and the reason why you are including them."
          conditional :trading_figures, :yes
          details_words_max 100
        end

        options :export_agent, "Are you an export agent/merchant/wholesaler?" do
          ref "A 15"
          required
          yes_no
          context %(
            <p>
              An export agent exports goods/services on behalf of another company in exchange for a commission. An export merchant buys merchandise to sell on at a higher price (sometimes rebranding/repacking in the process).
            </p>
          )
        end

        options :export_unit, "Are you an export unit?" do
          ref "A 16"
          required
          yes_no
          help "What is an export unit?", %(
            <p>An export unit is a subsidiary or operating unit of a larger company that manages the company's export activities.</p>
          )
        end

        upload :org_chart, "Upload an organisational chart." do
          ref "A 17"
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
      end
    end
  end
end
