class QAE2014Forms
  class << self
    def trade_step3
      @trade_step3 ||= Proc.new {
        # TODO Hide this when A5 "List the Queen's Award(s) you currently hold" has a value "International Trade (6 years)"
        # Act as if this is preslected with "6 plus" for dependent questions below
        options :trade_commercial_success, "For how long has your organisation seen growth and commercial success in its international trade?" do
          ref 'C 1'
          required
          context %Q{
            <p>Your answer here will determine whether you are assessed for outstanding (over  three years) or continuous (over six years) achievement in international trade.</p>
          }
          option '3 to 5', '3-5 years'
          option '6 plus', '6 years or more'
        end

        # TODO Show this when A5 "List the Queen's Award(s) you currently hold" has a value "International Trade (6 years)"
        # Act as if the B1 above is preslected with "6 plus" for dependent questions below
        #header :trade_commercial_success_preselected, "Because you are the current holder of a Queen's Award for Continuous Achievement in International Trade (6 years), you may only apply for the Outstanding Achievement Award (3 years) this year." do
        #  ref 'C 1'
        #end

        by_years :financial_year_dates, 'State your financial year end date' do
          ref 'C 2'
          required
          type :date
          by_year_condition :trade_commercial_success, '3 to 5', 3
          by_year_condition :trade_commercial_success, '6 plus', 6
          context %Q{
            <p>If you haven't reached/finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application.</p>
          }
          conditional :trade_commercial_success, :true
        end

        number :employees, 'State the number of people employed by the company for each year of your entry.' do
          ref 'C 3'
          required
          context %Q{
            <p>State the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. Only include those on the payroll.</p>
          }
          unit ' years'
          style "small inline"
          min 2
          conditional :trade_commercial_success, :true
        end

        header :company_financials, 'Company Financials' do
          conditional :trade_commercial_success, :true
        end

        textarea :trade_excluded_explanation, 'Parent companies making group entries should include figures for all UK subsidiaries. If any part of the group is excluded, please provide an explanation here.' do
          ref 'C 4'
          rows 5
          words_max 150
          conditional :trade_commercial_success, :true
        end

        by_years :overseas_sales, 'Total overseas sales' do
          ref 'C 5'
          required
          type :money
          by_year_condition :trade_commercial_success, '3 to 5', 3
          by_year_condition :trade_commercial_success, '6 plus', 6
          conditional :trade_commercial_success, :true
        end

        by_years :overseas_sales_direct, 'of which direct' do
          classes "sub-question"
          required
          type :money
          by_year_condition :trade_commercial_success, '3 to 5', 3
          by_year_condition :trade_commercial_success, '6 plus', 6
          context %Q{
            <p>"Include figures for sales of goods/services to non-UK residents or their buying agents. Include royalties, license fees and other related services. Include sales to, and by, your overseas subsidiaries (though for what they buy fmor you to sell on, only include their markup).</p>
            <p>The goods/services must have been provided and the customer invoiced to be included - omit unfulfilled orders.</p>
            <p>Income from services in connection to imports into the UK (other than freight) should not be included. Sales to UK branches/subsidiaries of foreign companies, or sales for use in the UK, should not be included. However, services performed in the UK but invoiced to a non-UK resident can be included eg. tourism.</p><p>Include comission earned as export agents for UK goods or services.</p>
            <p>You should also include:</p>
            <ul class="list-alpha">
              <li>
                dividends remitted to the UK from direct investments in overseas branches, subsidiaries and associates in the same general line of business as the entrant, provided no earnings from such overseas branches, subsidiaries and associates have already been included elsewhere
              </li>
              <li>
                dividends remitted to the UK from direct investment in associates which are not in the same
                 general line of business
              </li>
              <li>
                interest on lending abroad remitted to the UK
              </li>
              <li>
                income from portfolio investment abroad remitted to the UK
              </li>
              <li>
                dividends on investments abroad not remitted to the UK provided no part of such dividends has been included directly or indirectly under notes a), b) and d) above
              </li>
              <li>
                other earnings from overseas residents remitted to the UK
              </li>
            </ul>
            <br>
          }
          conditional :trade_commercial_success, :true
        end

        by_years :overseas_sales_indirect, 'of which indirect' do
          classes "sub-question"
          required
          type :money
          by_year_condition :trade_commercial_success, '3 to 5', 3
          by_year_condition :trade_commercial_success, '6 plus', 6
          context %Q{
            <p>Direct overseas sales are the result of an organisation making a commitment to market overseas on its own behalf. Indirect overseas sales are where, for example:</p>
            <ul>
              <li>
                A home country agency is employed (ie an exporting company from the organisation’s own country - which handles exporting on its behalf) to get its product into an overseas market
              </li>
              <li>
                “Piggybacking” whereby the organisation’s product uses the existing distribution and logistics of another business
              </li>
              <li>
                Use of Export Management Houses (EMHs) that act as a bolt on export department for the organisation
              </li>
            </ul>
            <p>
              Indirect overseas sales are not eligible, except where:
            </p>
            <ul class="list-alpha">
              <li>
                several companies co-operate in a formally constituted consortium to fulfil major contracts overseas; or
              </li>
              <li>
                the provider of goods or services of UK origin enters into a joint venture partnership with a UK exporter; or
              </li>
              <li>
                an indirect exporter making a major contribution to an exported product (eg marine engine in a ship) can show that they have undertaken the selling effort, direct to the overseas customer, so that their component or equipment is included in the finished exported product.
              </li>
            </ul>
            <br>
          }
          conditional :trade_commercial_success, :true
        end

        by_years :total_turnover, 'Total turnover (home plus overseas)' do
          classes "sub-question"
          required
          type :money
          by_year_condition :trade_commercial_success, '3 to 5', 3
          by_year_condition :trade_commercial_success, '6 plus', 6
          context %Q{
            <p>Exclude VAT, overseas taxes and, where applicable, excise duties. </p>
          }
          conditional :trade_commercial_success, :true
          drop_conditional :drops_in_turnover
        end

        by_years :net_profit, 'Net profit after tax but before dividends' do 
          classes "sub-question"
          required
          type :money
          by_year_condition :trade_commercial_success, '3 to 5', 3
          by_year_condition :trade_commercial_success, '6 plus', 6
          conditional :trade_commercial_success, :true
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover, "Explain any drops in turnover or net profit, and any losses made." do
          classes "sub-question js-conditional-drop-question"
          rows 5
          words_max 500
          conditional :trade_commercial_success, :true
        end

        options :company_estimated_figures, 'Are any of these figures estimated?' do
          classes "sub-question"
          yes_no
          conditional :trade_commercial_success, :true
        end

        textarea :company_estimates_use, 'Explain the use of estimates, and how much of these are actual receipts or firm orders.' do
          classes "sub-question"
          rows 5
          words_max 200
          conditional :trade_commercial_success, :true
          conditional :company_estimated_figures, :yes
        end

        options :resale_overseas, 'Do you purchase your products/services (or any of their components) from overseas for resale overseas?' do
          classes "sub-question"
          yes_no
          context %Q{
            <p>Excluding raw materials and value added.</p>
          }
          conditional :trade_commercial_success, :true
        end

        by_years :total_imported_cost, 'Total cost of the products/services/components imported for resale overseas' do 
          classes "sub-question"
          required
          type :money
          by_year_condition :trade_commercial_success, '3 to 5', 3
          by_year_condition :trade_commercial_success, '6 plus', 6
          conditional :trade_commercial_success, :true
          conditional :resale_overseas, :true
          drop_conditional :drops_in_turnover
        end

        options :manufacture_overseas, 'Do you manufacture overseas?' do
          ref 'C 6'
          required
          yes_no
        end

        by_years :overseas_yearly_percentage, 'Indicate the yearly percentage of your goods produced overseas.' do 
          classes "sub-question"
          required
          type :percent
          by_year_condition :trade_commercial_success, '3 to 5', 3
          by_year_condition :trade_commercial_success, '6 plus', 6
          conditional :trade_commercial_success, :true
          conditional :manufacture_overseas, :true
        end

        textarea :manufacture_model_benefits, 'Describe the benefits of this business model to the UK.' do
          classes "sub-question"
          rows 5
          words_max 400
          conditional :manufacture_overseas, :true
        end

        options :operate_overseas, 'Do you run your overseas operations as a franchise?' do
          ref 'C 7'
          required
          yes_no
        end

        textarea :operate_model_benefits, 'Describe the benefits of this business model to the UK.' do
          classes "sub-question"
          required
          rows 5
          words_max 500
          conditional :operate_overseas, :true
        end

        options :received_grant, 'Have you received any grant funding to support this product/service?' do
          ref 'C 8'
          required
          yes_no
        end

        textarea :funding_details, 'Please give details of date(s), source(s) and level(s) of funding.' do
          classes "sub-question"
          required
          rows 5
          words_max 300
          conditional :received_grant, :true
        end
      }
    end
  end
end
