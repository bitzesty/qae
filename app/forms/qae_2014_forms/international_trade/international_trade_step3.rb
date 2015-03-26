class QAE2014Forms
  class << self
    def trade_step3
      @trade_step3 ||= proc do
        options_with_preselected_conditions :trade_commercial_success, "" do
          main_header %(
            How would you describe your organisation's growth and commercial success in international trade?
                    )
          classes "js-entry-period"
          ref "C 1"
          required
          option "3 to 5", "Outstanding growth over the last 3 years"
          option "6 plus", "Continuous growth over the last 6 years"
          placeholder_preselected_condition :queen_award_holder_details,             question_suffix: :category,
                                                                                     parent_question_answer_key: "international_trade_3",
                                                                                     answer_key: "international_trade_6",
                                                                                     question_value: "6 plus",
                                                                                     placeholder_text: %{
              As you currently hold a Queen's Award for Continuous Achievement in International Trade (3 years), you can only apply for the Outstanding Achievement Award (6 years).
            }
          placeholder_preselected_condition :queen_award_holder_details,             question_suffix: :category,
                                                                                     parent_question_answer_key: "international_trade_6",
                                                                                     answer_key: "international_trade_3",
                                                                                     question_value: "3 to 5",
                                                                                     placeholder_text: %{
              As you currently hold a Queen's Award for Continuous Achievement in International Trade (6 years), you can only apply for the Outstanding Achievement Award (3 years).
            }
          financial_date_selector({
            "3 to 5" => "3",
            "6 plus" => "6"
          })
        end

        innovation_financial_year_date :financial_year_date, "Please enter your financial year end date." do
          ref "C 2"
          required
          context %(
            <p>If you haven't reached/finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application.</p>
                    )
          financial_date_pointer
        end

        options :financial_year_date_changed, 'Did your year-end date change during your <span class="js-entry-period-subtext">3 or 6</span> year entry period?' do
          classes "sub-question js-financial-year-change"
          required
          yes_no
        end

        by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question"
          required
          type :date
          label ->(y) { "Financial year #{y}" }
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          conditional :trade_commercial_success, :true
          conditional :financial_year_date_changed, "yes"
        end

        textarea :financial_year_date_changed_explaination, "Please explain why your year-end date changed." do
          classes "sub-question"
          required
          rows 5
          words_max 100
          conditional :financial_year_date_changed, "yes"
        end

        by_years :employees, "Enter the number of people employed by your organisation in each year of your entry." do
          ref "C 3"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. Only include those on the payroll.</p>
                    )
          type :number
          label ->(y) { "Financial year #{y}" }
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          conditional :trade_commercial_success, :true
          conditional :financial_year_date_changed, :true
        end

        header :company_financials, "Company Financials" do
          context %(
            <p>These figures should be for your entire organisation. If you haven't reached your latest year-end, please use estimates to complete this section.</p>
                    )
          conditional :trade_commercial_success, :true
          conditional :financial_year_date_changed, :true
        end

        textarea :innovation_excluded_explanation, "In question A12.3 you said you are applying on behalf of a group but are excluding some member(s)'s financial figures. Please explain why." do
          ref "C 4"
          rows 5
          words_max 150
          conditional :trade_commercial_success, :true
          conditional :financial_year_date_changed, :true
          conditional :applying_for, "organisation"
          conditional :parent_group_entry, "yes"
          conditional :pareent_group_excluding, "yes"
        end

        options :do_you_want_to_calculate_overseas_and_so_on, "If your organisation is in the financial (or related) services sector and is cyclical in nature, you can calculate overseas sales and total sales as rolling averages. Do you want to do this?" do
          ref "C 5"
          context %(
            <p>Entries for Outstanding Achievement must submit three three-year rolling averages, whilst Continuous Achievement requires six six-year rolling averages.</p>
                    )
          conditional :trade_commercial_success, :true
          yes_no
        end

        # TODO: add validation "Must be greater than £100,000"
        by_years :overseas_sales, "Total overseas sales" do
          ref "C 6"
          required
          context %(
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
                    )
          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          conditional :trade_commercial_success, :true
          drop_block_conditional
        end

        by_years :overseas_sales_direct, "of which direct" do
          classes "sub-question"
          required
          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %{
            <p>Include figures for sales of goods/services to non-UK residents or their buying agents. Include royalties, license fees and other related services. Include sales to, and by, your overseas subsidiaries (though for what they buy from you to sell on, only include their markup).</p>
            <p>The goods/services must have been provided and the customer invoiced to be included - omit unfulfilled orders.</p>
            <p>Income from services in connection to imports into the UK (other than freight) should not be included. Sales to UK branches/subsidiaries of foreign companies, or sales for use in the UK, should not be included. However, services performed in the UK but invoiced to a non-UK resident can be included eg. tourism.</p><p>Include commission earned as export agents for UK goods or services.</p>
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
          drop_block_conditional
        end

        by_years :overseas_sales_indirect, "of which indirect" do
          classes "sub-question"
          required
          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %{
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
          drop_block_conditional
        end

        by_years :total_turnover, "Total turnover (home plus overseas)" do
          classes "sub-question"
          type :money
          required
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %(
            <p>Exclude VAT, overseas taxes and, where applicable, excise duties.</p>
                    )
          conditional :trade_commercial_success, :true
          drop_conditional :drops_in_turnover
        end

        by_years :net_profit, "Net profit after tax but before dividends" do
          classes "sub-question"
          required
          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %(
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
                    )
          conditional :trade_commercial_success, :true
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover, "Explain any drops in turnover or net profit, and any losses made." do
          classes "sub-question js-conditional-drop-question"
          rows 5
          words_max 500
          conditional :trade_commercial_success, :true
          drop_condition_parent
        end

        options :resale_overseas, "Do you purchase your products/services (or any of their components) from overseas for resale overseas?" do
          classes "sub-question"
          required
          yes_no
          context %(
            <p>Excluding raw materials and value added.</p>
                    )
          conditional :trade_commercial_success, :true
        end

        by_years :total_imported_cost, "Total cost of the products/services/components imported for resale overseas" do
          classes "sub-question"
          required
          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %(
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.
                    )
          conditional :trade_commercial_success, :true
          conditional :resale_overseas, "yes"
          drop_conditional :drops_in_turnover
        end

        options :company_estimated_figures, "Are any of these figures estimated?" do
          ref "C 7"
          yes_no
          conditional :trade_commercial_success, :true
        end

        textarea :company_estimates_use, "Explain the use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          rows 5
          words_max 400
          conditional :trade_commercial_success, :true
          conditional :company_estimated_figures, "yes"
        end

        options :manufacture_overseas, "Do you manufacture overseas?" do
          ref "C 8"
          required
          yes_no
        end

        by_years :overseas_yearly_percentage, "Indicate the yearly percentage of your goods produced overseas." do
          classes "sub-question"
          required
          type :percent
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          conditional :trade_commercial_success, :true
          conditional :manufacture_overseas, "yes"
        end

        textarea :manufacture_model_benefits, "Describe the benefits of this business model to the UK." do
          classes "sub-question"
          rows 5
          words_max 400
          conditional :manufacture_overseas, "yes"
        end

        options :operate_overseas, "Do you run your overseas operations as a franchise?" do
          ref "C 9"
          required
          yes_no
        end

        textarea :operate_model_benefits, "Describe the benefits of this business model to the UK." do
          classes "sub-question"
          required
          rows 5
          words_max 500
          conditional :operate_overseas, "yes"
        end

        options :received_grant, "Did you receive any grant funding to support this product/service?" do
          ref "C 10"
          required
          yes_no
        end

        textarea :funding_details, "Please give details of date(s), source(s) and level(s) of funding." do
          classes "sub-question"
          required
          rows 5
          words_max 300
          conditional :received_grant, "yes"
        end
      end
    end
  end
end
