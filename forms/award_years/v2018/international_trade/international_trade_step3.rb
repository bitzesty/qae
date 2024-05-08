# -*- coding: utf-8 -*-
class AwardYears::V2018::QaeForms
  class << self
    def trade_step3
      @trade_step3 ||= proc do
        header :commercial_success_info_block, "" do
          context %(
            <p>
              In order to be eligible for this Award, your business must demonstrate financial stability and growth for the last 3 years.
            </p>
            <p>
              <strong>If you haven't reached your latest year-end, please use estimates to complete this section.</strong>
            </p>
          )
        end

        header :commercial_success_intro, "" do
          classes "application-notice help-notice"
          context %(
            <p>
              If your application is shortlisted you will have to supply commercial figures verified by an independent accountant within a specified deadline.
            </p>
          )
        end

        trade_commercial_success :trade_commercial_success, "How you would describe the impact of your international trade activities on your organisation's financial performance?" do
          classes "js-entry-period"
          ref "C 1"
          required
          option "3 to 5", "Outstanding Short Term Growth: international trade has resulted in outstanding year on year growth in the last 3 years with no dips"
          option "6 plus", "Outstanding Continuous Growth: international trade has resulted in continuous year on year growth in the last 6 years with no dips"
          placeholder_preselected_condition :queen_award_holder_details,
            question_suffix: :year,
            question_value: "3 to 5",
            placeholder_text: %(
              As you currently hold a Queen's Award in International Trade, you can only apply for the Outstanding Achievement Award (3 years).
            )

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
          )
        end

        innovation_financial_year_date :financial_year_date, "Please enter your financial year end date" do
          ref "C 2"
          required
          context %(
            <p>
              If you haven't reached or finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application. If shortlisted, these figures will need to be verified by an independent accountant within a specified deadline.
            </p>
          )
          financial_date_pointer
        end

        options :financial_year_date_changed, "Did your year-end date change during your (<span class='js-entry-period-subtext'>3 or 6</span> year) entry period?" do
          classes "sub-question js-financial-year-change"
          sub_ref "C 2.1"
          required
          yes_no
          context %(
            <p>
              We ask this to obtain all of the commercial figures we need to assess your application. You should ensure that any data supporting your application covers <span class='js-entry-period-subtext'>3 or 6</span> full 12-month periods.
            </p>
          )
          default_option "no"
        end

        by_years_label :financial_year_changed_dates, "Please enter your year-end dates for each financial year" do
          classes "sub-question"
          sub_ref "C 2.2"
          required
          type :date
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")

          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          conditional :trade_commercial_success, :true
          conditional :financial_year_date_changed, "yes"
        end

        textarea :financial_year_date_changed_explaination, "Please explain why your year-end date changed" do
          classes "sub-question"
          sub_ref "C 2.3"
          required
          rows 5
          words_max 100
          conditional :financial_year_date_changed, "yes"
        end

        by_years :employees, "Enter the number of people employed by your organisation in the UK in each year of your entry" do
          classes "question-employee-min"
          ref "C 3"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. </p>
          )
          type :number
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")

          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
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
              Please do not separate your figures with commas
            </p>
          )
        end

        by_years :overseas_sales, "Total overseas sales" do
          ref "C 4.1"
          required
          context %(
            <p>
              Please include only:
            </p>
            <ul>
              <li>
                Direct overseas sales of all products and services (including income from royalties, licence fees, provision of know-how etc.).
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
              If applicable include your sales to and the sales by, your overseas branches or subsidiaries. For products /services which you sell/invoice to them and they sell/invoice on, include only their mark-up, if any, over the price paid to you.
            </p>
            <p>
              The products/services must have been shipped/provided and the customer invoiced, but you need not have received payment within the year concerned. Omit unfulfilled orders and payments received in advance of export.
            </p>
          )

          pdf_context %(
            <p>
              Please include only:
            </p>
            <p>
              \u2022 Direct overseas sales of all products and services (including income from royalties, licence fees, provision of know-how etc.).

              \u2022 Total export agency commissions.

              \u2022 Dividends remitted to the UK from direct overseas investments.

              \u2022 Income from portfolio investment abroad remitted to the UK.

              \u2022 Dividends on investments abroad not remitted to the UK.

              \u2022 Other earnings from overseas residents remitted to the UK.
            </p>
            <p>
              If applicable include your sales to and the sales by, your overseas branches or subsidiaries. For products /services which you sell/invoice to them and they sell/invoice on, include only their mark-up, if any, over the price paid to you.
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

        by_years :total_turnover, "Total turnover (UK and overseas)" do
          classes "sub-question"
          sub_ref "C 4.2"
          type :money
          required
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %(
            <p>Exclude VAT, overseas taxes and, where applicable, excise duties.</p>
                    )
          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")
          drop_conditional :drops_in_turnover
        end

        by_years :net_profit, "Net profit after tax but before dividends (UK and overseas)" do
          classes "sub-question"
          sub_ref "C 4.3"
          required
          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %(
            <p>
              Use a minus symbol to record any losses.
            </p>
          )
          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover, "Explain any drops in total turnover or net profit, and any losses made. Sustained or unexplained losses may lead to the entry being rejected" do
          classes "sub-question js-conditional-drop-question"
          sub_ref "C 4.4"
          rows 5
          words_max 300
          drop_condition_parent
        end
      end
    end
  end
end
