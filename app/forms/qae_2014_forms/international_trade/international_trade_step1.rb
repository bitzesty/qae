class QAE2014Forms
  class << self
    def trade_step1
      @trade_step1 ||= proc do
        options :applying_for, "Are you applying on behalf of your:" do
          ref "A 1"
          required
          option "organisation", "Whole organisation"
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
            <p>We recommend that you apply as a principal. A principal invoices its customers (or their buying agents) and is the body to receive those payments.</p>
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

        # TODO: Hardcoded date
        date :started_trading, "Date started trading" do
          required
          ref "A 5"
          context "<p>Organisations that began trading after <span class='todo-placeholder'>01/10/2012</span> aren't eligible for this award.</p>"
          date_max "01/10/2012"
        end

        # TODO: Hardcoded date
        options :queen_award_holder, "Are you a current Queen's Award holder <span class='todo-placeholder'>(2010-2014)</span>?" do
          required
          ref "A 6"
          yes_no
        end

        queen_award_holder :queen_award_holder_details, "List the Queen's Award(s) you currently hold" do
          classes "sub-question"
          sub_ref "A 6.1"

          conditional :queen_award_holder, :yes

          category :innovation_2, "Innovation (2 years)"
          category :innovation_5, "Innovation (5 years)"
          category :international_trade_3, "International Trade (3 years)"
          category :international_trade_6, "International Trade (6 years)"
          category :sustainable_development_2, "Sustainable Development (2 years)"
          category :sustainable_development_5, "Sustainable Development (5 years)"

          year 2010
          year 2011
          year 2012
          year 2013
          year 2014

          children_options_depends_on :category
          dependable_values [:international_trade_3, :international_trade_6]
        end

        options :business_name_changed, "Have you changed the name of your organisation since your last entry?" do
          classes "sub-question"

          option "yes", "Yes"
          option "no", "No"
          option "first", "This is our first ever entry"
        end

        text :previous_business_name, "Name used previously" do
          classes "regular-question"
          sub_ref "A 6.2"
          required
          conditional :business_name_changed, :yes
        end

        textarea :previous_business_ref_num, "Reference number(s) used previously" do
          classes "regular-question"
          sub_ref "A 6.3"
          required
          conditional :business_name_changed, :yes
          rows 5
          words_max 100
        end

        options :other_awards_won, "Have you won any other business awards in the past?" do
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

        address :principal_address, "Principal address of your organisation" do
          required
          ref "A 8"
        end

        text :org_telephone, "Main telephone number" do
          required
          ref "A 9"
          style "small"
        end

        text :website_url, "Website Address" do
          ref "A 10"
          style "large"
          form_hint "e.g. www.example.com"
        end

        business_sector_dropdown :business_sector, "Business Sector" do
          required
          ref "A 11"
        end

        text :business_sector_other, "Please specify" do
          classes "regular-question"
          sub_ref "A 11.1"
          required
          conditional :business_sector, :other
        end

        header :parent_company_header, "Parent Companies" do
          ref "A 12"
          conditional :applying_for, :true
        end

        text :parent_company, "Name of immediate parent company" do
          classes "sub-question"
          sub_ref "A 12.1"
          conditional :applying_for, "division branch subsidiary"
        end

        country :parent_company_country, "Country of immediate parent company" do
          classes "regular-question"
          sub_ref "A 12.2"
          conditional :applying_for, "division branch subsidiary"
        end

        options :parent_ultimate_control, "Does your immediate parent company have ultimate control?" do
          classes "sub-question"
          sub_ref "A 12.3"
          conditional :applying_for, "division branch subsidiary"
          yes_no
        end

        text :ultimate_control_company, "Name of organisation with ultimate control" do
          classes "regular-question"
          sub_ref "A 12.4"
          conditional :parent_ultimate_control, :no
          conditional :applying_for, "division branch subsidiary"
        end

        country :ultimate_control_company_country, "Country of organisation with ultimate control" do
          classes "regular-question"
          sub_ref "A 12.5"
          conditional :parent_ultimate_control, :no
          conditional :applying_for, "division branch subsidiary"
        end

        options :parent_group_entry, "Are you a parent company making a group entry?" do
          classes "sub-question"
          conditional :applying_for, :true
          sub_ref "A 12.6"
          context %(
            <p>A 'group entry' is when you are applying on behalf of multiple divisions/branches/subsidiaries under your control.</p>
                    )
          yes_no
        end

        options :pareent_group_excluding, "Are you excluding any members of your group from this application?" do
          classes "sub-question"
          conditional :applying_for, :true
          sub_ref "A 12.7"
          conditional :parent_group_entry, "yes"
          yes_no
        end

        options :trading_figures, "Do you have any UK subsidiaries, associates or plants whose trading figures are included in this entry?" do
          ref "A 13"
          required
          yes_no
        end

        subsidiaries_associates_plants :trading_figures_add, "" do
          required
          sub_ref "A 13.1"
          conditional :trading_figures, :yes
        end

        options :export_agent, "Are you an export agent/merchant?" do
          ref "A 14"
          required
          yes_no
          context %(
            <p>
              An export agent exports goods/services on behalf of another company in exchange for commission. An export merchant buys merchandise to sell on at a higher price (sometimes rebranding/repacking in the process).
            </p>
          )
        end

        options :export_unit, "Are you an export unit?" do
          ref "A 15"
          required
          yes_no
          help "What is an export unit?", %(
            <p>An export unit is a subsidiary or operating unit of a larger company that manages the company's export activities.</p>
                    )
        end

        upload :org_chart, "Upload an organisational chart." do
          ref "A 16"
          context %(
            <p>You can submit files in all common formats, as long as they're less than 5mb.</p>
                    )
        end
      end
    end
  end
end
