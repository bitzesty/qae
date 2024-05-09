class AwardYears::V2021::QaeForms
  class << self
    def innovation_step3
      @innovation_step3 ||= proc do
        header :commercial_success_info_block, "" do
          context %(
            <h3>About this section</h3>
            <p>
              All applicants for any Queen’s Award must demonstrate a certain level of financial performance. This section enables you to show the impact that your innovation had on your organisation's financial performance.
            </p>
            <h3>Small organisations</h3>
            <p>
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            </p>
            <h3>Latest financial year and COVID-19</h3>
            <p>
              Typically, you would have to submit data for your latest financial year that falls before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_time} (the submission deadline). However, if your current financial year's performance has been affected by the spread of COVID-19, you may wish to consider using your previous year as the latest year. For example, if your year-end is 31 May 2020 you may want to use the financial year ending 31 May 2019 for your final set of financial figures.
            </p>
            <h3>Estimated figures</h3>
            <p>
              If you haven't reached or finalised your accounts for the latest year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "About this section"],
            [:normal, %(
              All applicants for any Queen’s Award must demonstrate a certain level of financial performance. This section enables you to show the impact that your innovation had on your organisation's financial performance.
            )],
            [:bold, "Small organisations"],
            [:normal, %(
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            )],
            [:bold, "Latest financial year and COVID-19"],
            [:normal, %(
              Typically, you would have to submit data for your latest financial year that falls before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_time} (the submission deadline). However, if your current financial year's performance has been affected by the spread of COVID-19, you may wish to consider using your previous year as the latest year. For example, if your year-end is 31 May 2020 you may want to use the financial year ending 31 May 2019 for your final set of financial figures.
            )],
            [:bold, "Estimated figures"],
            [:normal, %(
              If you haven't reached or finalised your accounts for the latest year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            )],
          ]
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

          context %(
            <p>
              Typically, you would have to submit data for your latest financial year that falls before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_time} (the submission deadline). However, if your current financial year's performance has been affected by the spread of COVID-19, you may wish to consider using your previous year as the latest year. For example, if your year-end is 31 May 2020 you may want to use the financial year ending 31 May 2019 for your final set of financial figures.
            </p>
            <p>
              If you haven't reached or finalised your accounts for the latest year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            </p>
          )

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")

          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
          conditional :innovation_performance_years, :true
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
            <h3>Group entries</h3>
            <p>
              A parent company making a group entry should include the trading figures of all UK members of the group.
            </p>

            <h3>Estimated figures</h3>
            <p>
              If you haven't reached or finalised your latest year-end yet, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            </p>

            <h3>Figures - format</h3>
            <p>
              You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound (do not enter pennies). Do not separate your figures with commas.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "Group entries"],
            [:normal, %(
              A parent company making a group entry should include the trading figures of all UK members of the group.
            )],
            [:bold, "Estimated figures"],
            [:normal, %(
              If you haven't reached or finalised your latest year-end yet, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            )],
            [:bold, "Figures - format"],
            [:normal, %(
              You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound (do not enter pennies). Do not separate your figures with commas.
            )],
          ]

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
        end

        textarea :drops_in_turnover, "Explain any drops in the total turnover, export sales, total net assets or net profit, and any losses made." do
          classes "sub-question"
          sub_ref "C 4.6"
          required
          rows 5
          words_max 300
          context %(
            <p>
              Sustained or unexplained drops or losses may lead to the entry being rejected.
            </p>
            <p>
              If you didn't have any drops in the total turnover, export sales, total net assets or net profit, or any losses, please state so.
            </p>
          )
        end

        textarea :drops_explain_how_your_business_is_financially_viable, "Explain how your business is financially viable, in terms of cash flow and cash generated." do
          classes "sub-question"
          sub_ref "C 4.7"
          required
          rows 5
          words_max 300
          context %(
            <p>
              If you are reporting drops or losses, to consider your application, we require an explanation of how your business is financially viable.
            </p>
            <p>
              If you didn't have any drops in the total turnover, export sales, total net assets or net profit, or any losses, please state so.
            </p>
          )
        end

        textarea :investment_strategy_and_its_objectives, "Please describe your investment strategy and its objectives, and, if applicable, the type and scale of investments you have received." do
          classes "sub-question"
          sub_ref "C 4.8"
          required
          rows 5
          words_max 300
          context %(
            <p>
              This information is particularly useful when ascertaining your company’s financial viability, especially when you have drops in total turnover and losses.
            </p>
          )

          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
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
            <h3>About this question</h3>
            <p>
              Some sub-questions may not apply to your innovation. Answer the ones that are relevant to help us understand the financial value of your innovation.
            </p>

            <h3>Estimated figures</h3>
            <p>
              If you haven't reached or finalised your latest year-end yet, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            </p>

            <h3>Figures - format</h3>
            <p>
              You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound (do not enter pennies). Do not separate your figures with commas.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "About this question"],
            [:normal, %(
              Some sub-questions may not apply to your innovation. Answer the ones that are relevant to help us understand the financial value of your innovation.
            )],
            [:bold, "Estimated figures"],
            [:normal, %(
              If you haven't reached or finalised your latest year-end yet, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            )],
            [:bold, "Figures - format"],
            [:normal, %(
              You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound (do not enter pennies). Do not separate your figures with commas.
            )],
          ]
        end

        by_years :units_sold, "Number of innovative units/contracts sold (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.1"
          type :number
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
        end

        by_years :sales, "Sales of your innovative product/service (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.2"
          type :money
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
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
        end

        textarea :drops_in_sales, "Explain any drop in sales or number of units sold (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.5"
          rows 5
          words_max 250
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

          context %(
            <p>
              If you haven't reached or finalised your latest year-end yet, it is acceptable to use estimated figures. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            </p>
          )

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

        textarea :roi_details, "Please provide calculations on how you have recovered or will recover the investment above. How long did it take or will it take to recover the investment?" do
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
