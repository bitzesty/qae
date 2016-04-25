class QAE2014Forms
  class << self
    def innovation_step3
      @innovation_step3 ||= proc do
        header :commercial_success_intro, "" do
          classes "application-notice help-notice"
          context %(
            <p>
              If your application is shortlisted you will have to supply verified commercial figures.
            </p>
          )
        end

        options :innovation_performance_years, "How would you describe the impact of your innovation on your organisation's financial performance?" do
          classes "js-entry-period"
          ref "C 1"
          required
          context %{
            <p>Your answer here will determine whether you are assessed for outstanding innovation (over two years) or continuous innovation (over five years).</p>
          }
          option "2 to 4", "Outstanding performance improvements in the last 2 years"
          option "5 plus", "Steady performance improvements in the last 5 years"
          financial_date_selector({
            "2 to 4" => "2",
            "5 plus" => "5"
          })
          sub_category_question
        end

        innovation_financial_year_date :financial_year_date, "Please enter your financial year end date." do
          ref "C 2"
          required
          context %(
            <p>If you haven't reached/finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application.</p>
                    )
          financial_date_pointer
        end

        options :financial_year_date_changed, "Did your year-end date change during your <span class='js-entry-period-subtext'>2 or 5</span> year entry period?" do
          classes "sub-question js-financial-year-change"
          sub_ref "C 2.1"
          required
          yes_no
        end

        by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question"
          sub_ref "C 2.2"
          required
          type :date
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :yes
        end

        textarea :financial_year_date_changed_explaination, "Please explain why your year-end date changed." do
          classes "sub-question"
          sub_ref "C 2.3"
          required
          rows 5
          words_max 100
          conditional :financial_year_date_changed, :yes
        end

        by_years :employees, "Enter the number of people employed by your organisation in the UK in each year of your entry." do
          classes "question-employee-min"
          ref "C 3"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. Only include those on the payroll.</p>
                    )
          type :number
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true

          employees_question
        end

        options :innovation_part_of, "How does your innovation fit within the overall business?" do
          ref "C 4"
          required
          option :entire_business, "It's integral to the whole business"
          option :single_product_or_service, "It affects a single product/service"
        end

        header :company_financials, "Company Financials" do
          context %(
            <p>
              A parent company making a group entry should include the trading figures of all UK members of the group.
            </p>
            <p>
              If you haven't reached your latest year-end, please use estimates to complete this section.
            </p>
            <p>
              You must enter actual financial figures in £ sterling (ignoring pennies).
            </p>
            <p>
              Please do not separate your figures with commas
            </p>
          )
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        by_years :total_turnover, "Total turnover" do
          ref "C 5"
          required
          context %(
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
                    )

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        by_years :exports, "Of which exports" do
          classes "sub-question"
          sub_ref "C 5.1"
          required
          context %(<p>Please enter '0' if you had none.</p>)

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        # UK sales = turnover - exports
        turnover_exports_calculation :uk_sales, "UK Sales" do
          classes "sub-question"
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          turnover :total_turnover
          exports :exports
        end

        by_years :net_profit, "Net profit after tax but before dividends (UK and overseas)" do
          classes "sub-question"
          sub_ref "C 5.2"
          required

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
          context %(
            <p>
              Use a minus symbol to record any losses.
            </p>
          )
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        by_years :total_net_assets, "Total net assets" do
          classes "sub-question total-net-assets"
          sub_ref "C 5.3"
          required
          context %{<p>As per your balance sheet. Total assets (fixed and current), less liabilities (current and long-term).</p>}

          type :money
          label ->(y) { "As at the end of year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover, "Explain any drops in turnover, export sales, total net assets and net profits, as well as any losses made." do
          classes "sub-question js-conditional-drop-question"
          sub_ref "C 5.4"
          rows 5
          words_max 200
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_condition_parent
        end

        header :product_financials, "Product/Service Financials" do
          ref "C 6"
          context %(
            <p>
              If you haven't reached your latest year-end, please use estimates to complete these questions.
            </p>
          )
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        by_years :units_sold, "Number of innovative units/contracts sold" do
          classes "sub-question"
          sub_ref "C 6.1"
          required

          type :number
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_sales
        end

        by_years :sales, "Sales of your innovative product/service" do
          classes "sub-question"
          sub_ref "C 6.2"
          required

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_sales
        end

        by_years :sales_exports, "Of which exports" do
          classes "sub-question"
          sub_ref "C 6.3"
          context %(<p>Please enter '0' if you had none.</p>)
          required

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_sales
        end

        by_years :sales_royalties, "Of which royalties or licenses" do
          classes "sub-question"
          sub_ref "C 6.4"
          context %(<p>Please enter '0' if you had none.</p>)
          required

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_sales
        end

        textarea :drops_in_sales, "Explain any drop in sales or number of units sold" do
          classes "sub-question js-conditional-drop-question"
          sub_ref "C 6.5"
          rows 5
          words_max 300
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_condition_parent
        end

        by_years :avg_unit_price, "Average unit selling price/contract value" do
          classes "sub-question"
          sub_ref "C 6.6"
          required

          context %(
            <p>
              If you haven't reached your latest year-end, please use estimates to complete this question.
            </p>
          )
          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        textarea :avg_unit_price_desc, "Explain your unit selling prices/contract values, highlighting any changes over the above periods." do
          classes "sub-question"
          sub_ref "C 6.7"
          required
          rows 5
          words_max 300
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        by_years :avg_unit_cost_self, "Direct cost, to you, of a single unit/contract" do
          classes "sub-question"
          sub_ref "C 6.8"
          required

          context %(
            <p>
              If you haven't reached your latest year-end, please use estimates to complete this question.
            </p>
          )
          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        textarea :costs_change_desc, "Explain your direct unit/ contract costs, highlighting any changes over the above periods." do
          classes "sub-question"
          sub_ref "C 6.9"
          required
          rows 5
          words_max 300
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        options :product_estimated_figures, "Are any of the figures used on this page estimates?" do
          ref "C 7"
          yes_no
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        textarea :product_estimates_use, "Explain your use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "C 7.1"
          rows 5
          words_max 200
          conditional :product_estimated_figures, :yes
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        textarea :financial_comments, "Additional comments (optional)" do
          classes "sub-question"
          sub_ref "C 7.2"
          rows 5
          words_max 100
          conditional :innovation_part_of, :true
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        textarea :innovation_performance, "Describe how, when, and to what extent the innovation improved the commercial performance of your business." do
          ref "C 8"
          required
          context %(
            <p>e.g. new sales, cost savings, and their overall effect on turnover and profitability.</p>
                    )
          rows 5
          words_max 300
        end

        textarea :investments_details, "Please enter details of all your investments in the innovation. *Include all investments made both during and prior to your entry period.* Also include the year(s) in which they were made." do
          ref "C 9"
          required
          rows 5
          words_max 300
        end

        textarea :roi_details, "How long did it take you to recover the investment indicated above? When and how did you achieve this?" do
          classes "sub-question"
          required
          rows 5
          words_max 300
        end
      end
    end
  end
end
