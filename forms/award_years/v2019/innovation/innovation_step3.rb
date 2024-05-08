# -*- coding: utf-8 -*-
class AwardYears::V2019::QaeForms
  class << self
    def innovation_step3
      @innovation_step3 ||= proc do
        header :commercial_success_info_block, "" do
          context %(
            <p>
              All applicants for a Queen’s Award must demonstrate a certain level of financial performance. This section enables you to demonstrate the impact that your innovation had on your organisation's financial performance.
            </p>
          )
        end

        header :commercial_success_intro, "" do
          classes "application-notice help-notice"
          context %(
            <p>
              You can provide estimated figures for now but, should you be shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            </p>
          )
        end

        options :innovation_performance_years, "How would you describe the impact of your innovation on your organisation's financial performance?" do
          classes "js-entry-period"
          ref "C 1"
          required
          context %(
            <p>
              Your answer here will determine whether you are assessed for outstanding innovation (over two years) or continuous innovation (over five years).
            </p>
          )
          option "2 to 4", "Outstanding Commercial Performance: innovation has improved commercial performance over two years"
          option "5 plus", "Continuous Commercial Performance: innovation has improved commercial performance over five years"
          financial_date_selector({
            "2 to 4" => "2",
            "5 plus" => "5",
          })
          default_option "5 plus"
          sub_category_question
        end

        innovation_financial_year_date :financial_year_date, "Enter your financial year end date." do
          ref "C 2"
          required
          context %(
            <p>If you haven't reached or finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application. If shortlisted, these figures will need to be verified by an independent accountant within a specified deadline.</p>
          )
          financial_date_pointer
        end

        options :financial_year_date_changed, "Did your year-end date change during your <span class='js-entry-period-subtext'>2 or 5</span> year entry period?" do
          classes "sub-question js-financial-year-change"
          sub_ref "C 2.1"
          required
          yes_no
          context %(
            <p>
              We ask this to obtain all of the commercial figures we need to assess your application. You should ensure that any data supporting your application covers two or five full 12-month periods.
            </p>
          )
          default_option "no"
        end

        by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question"
          sub_ref "C 2.2"
          required
          type :date
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")

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
            <p>You can use the number of full-time employees at the year-end, or the average for the 12-month period. Part-time employees should be expressed in full-time equivalents.</p>
          )
          type :number
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")

          employees_question
        end

        header :company_financials, "Company Financials" do
          ref "C 4"
          context %(
            <p>
              A parent company making a group entry should include the trading figures of all UK members of the group.
            </p>
            <p>
              You must enter actual financial figures in £ sterling (ignoring pennies).
            </p>
            <p>
              Do not separate your figures with commas.
            </p>
          )

          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        by_years :total_turnover, "Total turnover" do
          ref "C 4.1"
          required
          classes "sub-question"

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        by_years :exports, "Of which exports" do
          classes "sub-question"
          sub_ref "C 4.2"
          required
          context %(<p>Enter '0' if you had none.</p>)

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        # UK sales = turnover - exports
        turnover_exports_calculation :uk_sales, "Of which UK sales" do
          classes "sub-question"
          sub_ref "C 4.3"
          context %(<p>This number is automatically calculated using your total turnover and export figures.</p>)
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          turnover :total_turnover
          exports :exports
        end

        by_years :net_profit, "Net profit after tax but before dividends (the UK and overseas)" do
          classes "sub-question"
          sub_ref "C 4.4"
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

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")

          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        by_years :total_net_assets, "Total net assets" do
          classes "sub-question total-net-assets"
          sub_ref "C 4.5"
          required
          context %(
            <p>
              As per your balance sheet. Total assets (fixed and current) minus liabilities (current and long-term).
            </p>
          )

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")

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
          sub_ref "C 4.6"
          rows 5
          words_max 200

          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_condition_parent
        end

        options :innovation_part_of, "How does the innovation that forms the basis of this application fit within the overall business?" do
          ref "C 5"
          required
          option :entire_business, "It's integral to the whole business"
          option :single_product_or_service, "It affects a single product/service"
          context %(
            <p>
              It is important that we know whether or not your innovation is the key thing your business does or forms part of a wider approach. This is so we can understand the value of your innovation in the context of your overall commercial performance.
            </p>
          )
        end

        header :product_financials, "Innovation Financials" do
          ref "C 6"
          context %(
            <p>
              If applicable, provide your unit price, cost details and sales figures to help us understand the value of the innovation.
            </p>
            <p>
              Some questions may not apply, answer the ones that are applicable to your innovation.
            </p>
            <p>
              You must enter actual financial figures in £ sterling (ignoring pennies). Do not separate your figures with commas.
            </p>
          )
        end

        by_years :units_sold, "Number of innovative units/contracts sold (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.1"
          type :number
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
          drop_conditional :drops_in_sales
        end

        by_years :sales, "Sales of your innovative product/service (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.2"
          type :money
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
          drop_conditional :drops_in_sales
        end

        by_years :sales_exports, "Of which exports (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.3"
          context %(<p>Enter '0' if you had none.</p>)
          type :money
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
          drop_conditional :drops_in_sales
        end

        by_years :sales_royalties, "Of which royalties or licences (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.4"
          context %(<p>Enter '0' if you had none.</p>)
          type :money
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
          drop_conditional :drops_in_sales
        end

        textarea :drops_in_sales, "Explain any drop in sales or number of units sold (if applicable)." do
          classes "sub-question js-conditional-drop-question"
          sub_ref "C 6.5"
          rows 5
          words_max 250
          drop_condition_parent
        end

        by_years :avg_unit_price, "Average unit selling price/contract value (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.6"
          context %(
            <p>
              If your innovation is a product, you must provide the unit price.
            </p>
          )

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
        end

        textarea :avg_unit_price_desc, "Explain your unit selling prices/contract values, highlighting any changes over the above periods (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.7"
          rows 5
          words_max 250
        end

        by_years :avg_unit_cost_self, "Direct cost, to you, of a single unit/contract (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.8"
          context %(
            <p>If you haven't reached your latest year-end, use estimates to complete this question.</p>
          )
          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
        end

        textarea :costs_change_desc, "Explain your direct unit/ contract costs, highlighting any changes over the above periods (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.9"
          rows 5
          words_max 250
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

        textarea :innovation_performance, "Describe how, when, and to what extent the innovation has improved the commercial performance of your business. If further improvements are still anticipated, clearly demonstrate how and when in the future they will be delivered." do
          ref "C 8"
          required
          context %(
            <p>
              For example, new sales, cost savings, and their overall effect on turnover and profitability, new investment secured, new orders secured.
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :investments_details, "Enter details of all your investments in the innovation. Include all investments made both during and before your entry period. Also, include the year(s) in which they were made." do
          ref "C 9"
          required
          rows 5
          words_max 250
          context %(
            <p>
              This should include both capital purchases, and investments, grants, and loans received, as well as the cost of staff time and other non-cash resources.
            </p>
          )
        end

        textarea :roi_details, "How long did it take you to recover the investment indicated above? When and how did you achieve this?" do
          classes "sub-question"
          sub_ref "C 9.1"
          required
          rows 5
          words_max 250
          context %(
            <p>
              If your innovation is expected to recover its full costs in the future, explain how and when this will happen.
            </p>
          )
        end
      end
    end
  end
end
