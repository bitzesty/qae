# -*- coding: utf-8 -*-
class AwardYears::V2023::QaeForms
  class << self
    def trade_step3
      @trade_step3 ||= proc do
        header :commercial_success_info_block, "" do
          section_info
          context %(
            <h3 class="govuk-heading-m">About this section</h3>
            <p class="govuk-body">
              All applicants must demonstrate a certain level of financial performance. This section enables you to show the impact that your international trade activities have had on your organisation's financial performance. Financial information must be supplied so your organisation's commercial performance can be evaluated. It is important that these details are accurate as you will need to verify them if shortlisted.
            </p>
            <h3 class="govuk-heading-m">Small organisations</h3>
            <p class="govuk-body">
              Queen's Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all of the questions to a degree you can.
            </p>
            <h3 class="govuk-heading-m">Volatile markets & last financial year</h3>
            <p class="govuk-body">
              We recognise that recent volatile market conditions might have affected your growth plans. We will take this into consideration during the assessment process.
            </p>
            <p class="govuk-body">
              Also, typically, you would have to submit data for your last financial year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} (the submission deadline). However, if your latest financial performance has been affected by the volatile market conditions due to factors such as Covid, you may wish to use your last financial year before Covid. For example, if your year-end is 31 January 2022, you may want to use the financial year ending 31 January 2020 for your final set of financial figures.
            <p>
            <h3 class="govuk-heading-m">Estimated figures</h3>
            <p class="govuk-body">
              If you are providing figures for the year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} and haven't reached or finalised your accounts for that year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an external accountant by November. Typically, this would be an external accountant who prepares your annual accounts or returns or, in the case of a larger organisation, who conducts your financial audit.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "About this section"],
            [:normal, %(
              All applicants must demonstrate a certain level of financial performance. This section enables you to show the impact that your international trade activities have had on your organisation's financial performance. Financial information must be supplied so your organisation's commercial performance can be evaluated. It is important that these details are accurate as you will need to verify them if shortlisted.
            )],
            [:bold, "Small organisations"],
            [:normal, %(
              Queen's Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all of the questions to a degree you can.
            )],
            [:bold, "Volatile markets & last financial year"],
            [:normal, %(
              We recognise that recent volatile market conditions might have affected your growth plans. We will take this into consideration during the assessment process.

              Also, typically, you would have to submit data for your last financial year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} (the submission deadline). However, if your latest financial performance has been affected by the volatile market conditions due to factors such as Covid, you may wish to use your last financial year before Covid. For example, if your year-end is 31 January 2022, you may want to use the financial year ending 31 January 2020 for your final set of financial figures.
              )],
            [:bold, "Estimated figures"],
            [:normal, %(
              If you are providing figures for the year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} and haven't reached or finalised your accounts for that year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an external accountant by November. Typically, this would be an external accountant who prepares your annual accounts or returns or, in the case of a larger organisation, who conducts your financial audit.
            )]
          ]
        end

        trade_commercial_success :trade_commercial_success, "How would you describe the impact of your international trade activities on your organisation's financial performance?" do
          classes "js-entry-period"
          ref "C 1"
          required
          option "3 to 5", "Outstanding Short Term Growth: a steep year on year growth over three years"
          option "6 plus", "Outstanding Continued Growth: a substantial year on year growth over six years"
          placeholder_preselected_condition :applied_for_queen_awards_details,
            question_suffix: :year,
            question_value: "3 to 5",
            parent_question_answer_key: "3_years_application",
            placeholder_text: %(
              As you currently hold a Queen's Award in International Trade, you can only apply for the Outstanding Achievement Award (3 years).
            )

          placeholder_preselected_condition :applied_for_queen_awards_details,
            question_suffix: :year,
            question_value: "",
            parent_question_answer_key: "application_disabled",
            placeholder_text: %(
              As you currently hold a Queen's Award for International Trade, you cannot apply for another Award. You may apply in future years but can only use one year's financial performance from your Award winning application.
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
          )
        end

        innovation_financial_year_date :financial_year_date, "Enter your financial year end date." do
          ref "C 2"
          required
          financial_date_pointer
        end

        options :financial_year_date_changed, "Did your year-end date change during your (<span class='js-entry-period-subtext'>3 or 6</span> years) entry period?" do
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

        by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question"
          sub_ref "C 2.2"
          required
          type :date
          label ->(y) { "Financial year #{y}" }

          context %(
            <p>
              Typically, you would have to submit data for your last financial year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} (the submission deadline). However, if your latest financial performance has been affected by the volatile market conditions due to factors such as Covid, you may wish to use your last financial year before Covid. For example, if your year-end is 31 January 2022, you may want to use the financial year ending 31 January 2020 for your final set of financial figures.
            </p>
            <p>
              If you are providing figures for the year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} and haven't reached or finalised your accounts for that year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an external accountant by November. Typically, this would be an external accountant who prepares your annual accounts or returns or, in the case of a larger organisation, who conducts your financial audit.
            </p>
          )

          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")

          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          conditional :trade_commercial_success, :true
        end

        textarea :financial_year_date_changed_explaination, "Please explain why your year-end date changed." do
          classes "sub-question"
          sub_ref "C 2.3"
          required
          rows 5
          words_max 100
          conditional :financial_year_date_changed, "yes"
        end

        by_years :employees, "Enter the number of people employed by your organisation in the UK in each year of your entry." do
          classes "question-employee-min"
          ref "C 3"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents.</p>
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
            <h3 class='govuk-heading-m govuk-!-margin-bottom-1'>Group entries</h3>
            <p class='govuk-body'>
              A parent company making a group entry should include the trading figures of all UK members of the group.
            </p>

            <h3 class='govuk-heading-m govuk-!-margin-bottom-1'>Estimated figures</h3>
            <p class='govuk-body'>
              If you haven't reached or finalised your latest year-end yet, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an external accountant by November.
            </p>

            <h3 class='govuk-heading-m govuk-!-margin-bottom-1'>Figures - format</h3>
            <p class='govuk-body'>
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
              If you haven't reached or finalised your latest year-end yet, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an external accountant by November.
            )],
            [:bold, "Figures - format"],
            [:normal, %(
              You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound (do not enter pennies). Do not separate your figures with commas.
            )]
          ]
        end

        by_years :overseas_sales, "Total overseas sales" do
          ref "C 4.1"
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
            <p>
              If you haven't reached your latest year-end, use estimates to complete this question.
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
            <p>
              If you haven't reached your latest year-end, use estimates to complete this question.
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
            <p>
              Exclude VAT, overseas taxes and, where applicable, excise duties.
            </p>
                    )
          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")
        end

        by_years :net_profit, "Net profit after tax but before dividends (the UK and overseas)" do
          classes "sub-question"
          sub_ref "C 4.3"
          required
          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %(
            <p>
              If you haven't reached your latest year-end, use estimates to complete this question.
            </p>
            <p>
              Use a minus symbol to record any losses.
            </p>
          )
          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")
        end

        textarea :drops_in_turnover, "Explain any drops in the total turnover or net profit, and any losses made." do
          classes "sub-question"
          sub_ref "C 4.4"
          required
          context %(
            <p>
              Sustained or unexplained drops or losses may lead to the entry being rejected.
            </p>
            <p>
              If you didn't have any drops in the total turnover, export sales, total net assets or net profit, or any losses, please state so.
            </p>
          )
          rows 5
          words_max 300
        end

        textarea :drops_explain_how_your_business_is_financially_viable, "Explain how your business is financially viable in terms of cash flow and cash generated." do
          classes "sub-question"
          sub_ref "C 4.5"
          required
          rows 5
          words_max 300
        end

        textarea :investment_strategy_and_its_objectives, "Please describe your investment strategy and its objectives and, if applicable, the type and scale of investments you have received." do
          classes "sub-question"
          sub_ref "C 4.6"
          required
          rows 5
          words_max 300
        end

        textarea :covid_impact_details, "Explain how your business has been responding to volatile markets in recent years." do
          ref "C 5"
          required
          context %(
            <p>
              How have you adapted to or mitigated the impacts of recent volatile markets due to factors such as Covid, and with what results? How are you planning to respond in the year ahead? This could include opportunities you have identified as well as any contextual information or challenges you would like the assessors to consider.
            </p>
          )
          rows 4
          words_max 350
        end

        options :are_any_of_the_figures_used_estimates, "Are any of the figures used on this page estimates?" do
          ref "C 6"
          required
          context %(
            <p>
              If you haven't reached or finalised your latest year-end yet, it is acceptable to use estimated figures. If you are shortlisted, you will have to provide the actual figures that have been verified by an external accountant by November.
            </p>
          )
          yes_no
        end

        textarea :explan_the_use_of_estimates, "Explain the use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "C 6.1"
          required
          conditional :are_any_of_the_figures_used_estimates, :yes
          rows 5
          words_max 250
        end
      end
    end
  end
end
