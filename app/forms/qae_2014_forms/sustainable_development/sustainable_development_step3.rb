class QAE2014Forms
  class << self
    def development_step3
      @development_step3 ||= proc do
        options :development_performance_years, "How would you describe your achievements in sustainable development, and their contribution to your organisation's commercial performance?" do
          ref "C 1"
          required
          option "2 to 4", "Outstanding achievement over 2 years"
          option "5 plus", "Continuous achievement over 5 years"
          financial_date_selector({
            "2 to 4" => "2",
            "5 plus" => "5"
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

        options :financial_year_date_changed, 'Did your year-end date change during your <span class="js-entry-period-subtext">2 or 5</span> year entry period?' do
          classes "sub-question js-financial-year-change"
          required
          yes_no
        end

        by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question"
          required
          type :date
          label ->(y) { "Financial year #{y}" }
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :yes
        end

        textarea :financial_year_date_changed_explaination, "Please explain why your year-end date changed." do
          classes "sub-question"
          required
          rows 5
          words_max 100
          conditional :financial_year_date_changed, :yes
        end

        by_years :employees, "Enter the number of people employed by your organisation in each year of your entry." do
          ref "C 3"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. Only include those on the payroll.</p>
                    )
          type :number
          label ->(y) { "Financial year #{y}" }
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
        end
        # TODO: Min 2 - if less than 2 block - present 'you are not eligible' message

        options :entry_relates_to, "My entry relates to" do
          ref "C 4"
          required
          option :entire_business, "The entire business"
          option :single_product_or_service, "A single product or service"
        end

        header :company_financials, "Company Financials" do
          context %(
            <p>These figures should be for your entire organisation. If you haven't reached your latest year-end, please use estimates to complete this section.</p>
                    )
          conditional :development_performance_years, :true
        end

        textarea :development_excluded_explanation, "In question A13.3 you said you are applying on behalf of a group but are excluding some member(s)'s financial figures. Please explain why." do
          ref "C 5"
          required
          rows 5
          words_max 150
          conditional :development_performance_years, :true
          conditional :pareent_group_excluding, "yes"
        end

        by_years :total_turnover, "Total turnover" do
          ref "C 6"
          required
          context %(
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
                    )

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5

          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        by_years :exports, "Of which exports" do
          classes "sub-question"
          required
          context %(<p>Please enter '0' if you had none.</p>)

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5

          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        by_years :net_profit, "Net profit after tax but before dividends" do
          classes "sub-question"
          required

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5

          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        by_years :total_net_assets, "Total net assets" do
          classes "sub-question total-net-assets"
          required
          context %{<p>As per your balance sheet. Total assets (fixed and current), less liabilities (current and long-term).}

          type :money
          label ->(y) { "As at the end of year #{y}" }
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5

          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover, "Explain any drops in turnover, export sales, total net assets and net profits, as well as any losses made." do
          classes "sub-question js-conditional-drop-question"
          rows 5
          words_max 200
          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_condition_parent
        end

        options :company_estimated_figures, "Are any of these figures estimated?" do
          classes "sub-question"
          required
          yes_no
          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          conditional :entry_relates_to, :entire_business
        end

        textarea :company_estimates_use, "Explain your use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          required
          rows 5
          words_max 200
          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          conditional :company_estimated_figures, :yes
        end

        header :product_financials, "Product/Service Financials" do
          ref "C 7"
          context %(
            <p>If you haven't reached your latest year-end, please use estimates to complete these questions.</p>
                    )
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        by_years :units_sold, "Number of units/contracts sold" do
          classes "sub-question"
          required
          type :number
          label "..."
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
          drop_conditional :drops_in_sales
        end

        by_years :sales, "Sales" do
          classes "sub-question"
          required
          type :money
          label "..."
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
          drop_conditional :drops_in_sales
        end

        by_years :sales_exports, "of which exports" do
          classes "sub-question"
          context %(<p>Please enter '0' if you had none.</p>)
          required
          type :money
          label "..."
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
          drop_conditional :drops_in_sales
        end

        by_years :sales_royalties, "of which royalties or licenses" do
          classes "sub-question"
          context %(<p>Please enter '0' if you had none.</p>)
          required
          type :money
          label "..."
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
          drop_conditional :drops_in_sales
        end

        textarea :drops_in_sales, "Explain any drop in sales or number of units sold." do
          classes "sub-question js-conditional-drop-question"
          rows 5
          words_max 300
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
          drop_condition_parent
        end

        by_years :avg_unit_price, "Average unit selling price/contract value" do
          required
          type :money
          label "..."
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        textarea :avg_unit_price_desc, "Explain your unit selling prices/contract values, highlighting any changes over the above periods." do
          classes "sub-question"
          required
          rows 5
          words_max 200
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        by_years :avg_unit_cost_self, "Direct cost, to you, of a single unit/contract" do
          required
          type :money
          label "..."
          context %(
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
                    )
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        textarea :costs_change_desc, "Explain your direct unit/ contract costs, highlighting any changes over the above periods." do
          classes "sub-question"
          required
          rows 5
          words_max 300
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        options :product_estimated_figures, "Are any of these figures estimated?" do
          ref "C 8"
          required
          yes_no
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        textarea :product_estimates_use, "Explain the use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          required
          rows 5
          words_max 400
          conditional :product_estimated_figures, :yes
          conditional :development_performance_years, :true
        end

        textarea :financial_comments, "Additional comments (optional)" do
          ref "C 9"
          rows 5
          words_max 100
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        textarea :development_performance, "Explain the cost savings you or your customers' businesses made as a result of the introduction of the product/service/management approach." do
          ref "C 10"
          required
          context %(
            <p>Use figures if known.</p>
                    )
          rows 5
          words_max 300
        end

        textarea :investments_details, "Please enter details of all investments in your product/service/management approach. <span class='text-underline'>Include all investments made both during and prior to your entry period.</span> Also include the year(s) in which they were made." do
          ref "C 11"
          required
          rows 5
          words_max 500
        end

        textarea :roi_details, "How long did it take the investment indicated above to be repaid out of profits? When and how was this repayment achieved?" do
          ref "C 12"
          required
          context %(
            <p>When calculating expenditure paid for out of profits, please include capital costs where appropriate.</p>
                    )
          rows 5
          words_max 500
        end
      end
    end
  end
end
