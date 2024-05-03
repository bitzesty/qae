class AwardYears::V2024::QaeForms
  class << self
    def trade_step4
      @trade_step4 ||= proc do
        about_section :commercial_success_info_block, "" do
          section "trade_commercial_performance"
        end

        trade_commercial_success :trade_commercial_success, "Which award subcategory are you applying for?" do
          classes "js-entry-period"
          ref "D 1"
          required
          option "3 to 5",
                 "Outstanding Short-Term Growth: a steep year-on-year growth (without dips) over the three most recent financial years"
          option "6 plus",
                 "Outstanding Continued Growth: a substantial year-on-year growth (without dips) over the six most recent financial years"
          placeholder_preselected_condition :applied_for_queen_awards_details,
                                            question_suffix: :year,
                                            question_value: "3 to 5",
                                            parent_question_answer_key: "3_years_application",
                                            placeholder_text: %(
              As you currently hold a King's Award in International Trade, you can only apply for the Outstanding Achievement Award (3 years).
            )

          placeholder_preselected_condition :applied_for_queen_awards_details,
                                            question_suffix: :year,
                                            question_value: "",
                                            parent_question_answer_key: "application_disabled",
                                            placeholder_text: %(
              As you currently hold a King's Award for International Trade, you cannot apply for another Award. You may apply in future years but can only use one year's financial performance from your Award winning application.
            )

          additional_pdf_context I18n.t("pdf_texts.trade.queen_awards_question_additional_context")

          financial_date_selector({
            "3 to 5" => "3",
            "6 plus" => "6",
          })
          default_option "6 plus"
          sub_category_question
          context %(
            <p>
              Your answer here will determine whether you are assessed for outstanding growth (over three years) or continuous growth (over six years).
            </p>
            <p>
              To increase your chances of winning, we suggest you select the subcategory that best reflects your circumstances. Both subcategories enable you to use the King's Awards emblem for five years.
            </p>
          )
        end

        innovation_financial_year_date :financial_year_date, "Enter your financial year-end date." do
          ref "D 2"
          required
          financial_date_pointer
        end

        trade_most_recent_financial_year_options :most_recent_financial_year,
                                                 "Which year would you like to be your most recent financial year that you will submit figures for?" do
          ref "D 2.1"
          required
          option (AwardYear.current.year - 2).to_s, (AwardYear.current.year - 2).to_s
          option (AwardYear.current.year - 1).to_s, (AwardYear.current.year - 1).to_s
          default_option (AwardYear.current.year - 1).to_s

          classes "js-most-recent-financial-year"
          context %(
            <p>
              Answer this question if your dates in question D2 range between #{Settings.current_award_year_switch_date.decorate.formatted_trigger_date} to #{Settings.current_submission_deadline.decorate.formatted_trigger_date}.
            </p>
          )

          conditional :financial_year_date, :day_month_range, range: AwardYear.fy_date_range_threshold(minmax: true),
                                                              data: { value: AwardYear.fy_date_range_threshold(minmax: true, format: true), type: :range }
        end

        options :financial_year_date_changed,
                "Did your year-end date change during your <span class='js-entry-period-subtext'>three or six</span>-year entry period that you will be providing figures for?" do
          classes "sub-question js-financial-year-change"
          sub_ref "D 3"
          required
          yes_no
          default_option "no"
        end

        by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question"
          sub_ref "D 3.1"
          required
          type :date
          label ->(y) { "Financial year #{y}" }

          context %(
            <p>
              For the purpose of this application, your most recent financial year-end is your last financial year ending before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date("with_year")} - the application submission deadline.
            </p>
          )

          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")

          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          conditional :trade_commercial_success, :true
          conditional :financial_year_date_changed, :yes
        end

        textarea :financial_figures_adjustment_explanation, "Explain adjustments to figures." do
          classes "sub-question word-max-strict"
          sub_ref "D 3.2"
          required
          context %(
            <p>
              If your financial year-end has changed, you will need to agree with your accountants on how to allocate your figures so that they show three or six equal 12-month periods (36 consecutive months or 72 consecutive months). This allows for a comparison between years.
            </p>
            <p>
              Please note, these figures will need to be externally verified, so they should reflect the actual figures achieved within the relevant months of each 12-month period.
            </p>
            <p>
              Please explain what approach you will take to adjust the figures.
            </p>
          )
          rows 5
          words_max 200
          conditional :financial_year_date_changed, "yes"
        end

        textarea :financial_year_date_changed_explaination, "Explain why your year-end date changed." do
          classes "sub-question word-max-strict"
          sub_ref "D 3.3"
          required
          rows 5
          words_max 100
          conditional :financial_year_date_changed, "yes"
        end

        by_years :employees, "Enter the number of people employed by your organisation in the UK in each year of your entry." do
          classes "question-employee-min"
          ref "D 4"
          required
          context %(
            <p>
              You can use the number of full-time employees at the year-end or the average for the 12-month period. Part-time employees should be expressed in full-time equivalents (FTEs).
            </p>
          )
          type :number
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")

          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          employees_question
        end

        about_section :company_financials, "Company Financials" do
          ref "D 5"
          section "company_financials_trade"
        end

        by_years :overseas_sales, "Total overseas sales" do
          ref "D 5.1"
          classes "sub-question"
          required
          context %(
            <p>
              Include only:
            </p>
            <ul>
              <li>
                Direct overseas sales of all products and services (including income from royalties, licence fees, provision of know-how).
              </li>
              <li>
                Total export agency commissions.
              </li>
              <li>
                Dividends remitted to the UK from direct overseas investments.
              </li>
              <li>
                Income from portfolio investment abroad remitted to the UK.
              </li>
              <li>
                Dividends on investments abroad not remitted to the UK.
              </li>
              <li>
                Other earnings from overseas residents remitted to the UK.
              </li>
            </ul>
            <p>
              If applicable, include your sales to and the sales by your overseas branches or subsidiaries. For products/services which you sell/invoice to them and they sell/invoice on, include only their mark-up, if any, over the price paid to you.
            </p>
            <p>
              The products/services must have been shipped/provided and the customer invoiced, but you need not have received payment within the year concerned. Omit unfulfilled orders and payments received in advance of export.
            </p>
          )

          pdf_context %(
            <p>
              Include only:
            </p>
            <p>
              \u2022 Direct overseas sales of all products and services (including income from royalties, licence fees, provision of know-how).

              \u2022 Total export agency commissions.

              \u2022 Dividends remitted to the UK from direct overseas investments.

              \u2022 Income from portfolio investment abroad remitted to the UK.

              \u2022 Dividends on investments abroad not remitted to the UK.

              \u2022 Other earnings from overseas residents remitted to the UK.
            </p>
            <p>
              If applicable, include your sales to and the sales by your overseas branches or subsidiaries. For products/services which you sell/invoice to them and they sell/invoice on, include only their mark-up, if any, over the price paid to you.
            </p>
            <p>
              The products/services must have been shipped/provided and the customer invoiced, but you need not have received payment within the year concerned. Omit unfulfilled orders and payments received in advance of export.
            </p>
          )

          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")
          first_year_min_value "100000", "Cannot be less than £100,000"
          drop_block_conditional
        end

        by_years :total_turnover, "Total turnover (the UK and overseas)" do
          classes "sub-question"
          sub_ref "D 5.2"
          type :money
          required
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %(
            <p>
              Exclude VAT, overseas taxes and, where applicable, excise duties.
            </p>
                    )
          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")
        end

        by_years :net_profit, "Net profit after tax but before dividends (the UK and overseas)" do
          classes "sub-question"
          sub_ref "D 5.3"
          required
          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")
        end

        textarea :drops_in_turnover, "If you have had any losses, drops in turnover, or reductions in net profit, please explain them." do
          classes "sub-question"
          sub_ref "D 5.4"
          required
          context %(
            <p>
              Please note, when applicable, failure to answer this question may result in assessors not being able to fully assess your commercial performance, and therefore, your application may be rejected.
            </p>
            <p>
              If you didn't have any losses, drops in turnover, or reductions in net profit, please state so.
            </p>
          )
          rows 5
          words_max 300
        end

        textarea :drops_explain_how_your_business_is_financially_viable,
                 "Explain how your business is financially viable in terms of cash flow and cash generated." do
          classes "sub-question"
          sub_ref "D 5.5"
          required
          rows 5
          words_max 300
        end

        textarea :investment_strategy_and_its_objectives,
                 "Please describe your investment strategy and its objectives and, if applicable, the type and scale of investments you have received." do
          classes "sub-question"
          sub_ref "D 5.6"
          required
          rows 5
          words_max 300
        end

        options :are_any_of_the_figures_used_estimates, "Are any of the figures used on this page estimates?" do
          ref "D 6"
          required
          context %(
            <p>
              If you haven't reached or finalised your latest year-end yet, it is acceptable to use estimated figures.
            </p>
          )
          yes_no
        end

        confirm :agree_to_provide_actuals, "Agreement to provide actual figures" do
          classes "sub-question"
          sub_ref "D 6.1"
          required
          conditional :are_any_of_the_figures_used_estimates, :yes
          text %(
            I understand that if this application is shortlisted, I will have to provide actual figures that have been verified by an external accountant before the specified November deadline (the exact date will be provided in the shortlisting email).
          )
        end

        textarea :explan_the_use_of_estimates, "Explain the use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question word-max-strict"
          sub_ref "D 6.2"
          required
          conditional :are_any_of_the_figures_used_estimates, :yes
          rows 5
          words_max 250
        end
      end
    end
  end
end
