# -*- coding: utf-8 -*-
class AwardYears::V2023::QaeForms
  class << self
    def innovation_step3
      @innovation_step3 ||= proc do
        header :commercial_success_info_block, "" do
          section_info
          context %(
            <h3 class="govuk-heading-m">About section C</h3>
            <p class="govuk-body">
              All applicants must demonstrate a certain level of financial performance. This section enables you to show the impact that your innovation has had on your organisation's financial performance. Financial information must be supplied so your organisation's commercial performance can be evaluated. It is important that these details are accurate as you will need to verify them if shortlisted.
            </p>
            <h3 class="govuk-heading-m">Volatile markets & last financial year</h3>
            <p class="govuk-body">
              We recognise that recent volatile market conditions might have affected your growth plans. We will take this into consideration during the assessment process.
            </p>
            <p class="govuk-body">
              Also, typically, you would have to submit data for your last financial year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} (the submission deadline). However, if your latest financial performance has been affected by the volatile market conditions due to factors such as Covid, you may wish to use your last financial year before Covid. For example, if your year-end is 31 January 2022, you may want to use the financial year ending 31 January 2020 for your final set of financial figures.
            </p>
            <h3 class="govuk-heading-m">Estimated figures</h3>
            <p class="govuk-body">
              If you are providing figures for the year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} and haven't reached or finalised your accounts for that year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an external accountant by November. Typically, this would be an external accountant who prepares your annual accounts or returns or, in the case of a larger organisation, who conducts your financial audit.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "About section C"],
            [:normal, %(
              All applicants must demonstrate a certain level of financial performance. This section enables you to show the impact that your innovation has had on your organisation's financial performance. Financial information must be supplied so your organisation's commercial performance can be evaluated. It is important that these details are accurate as you will need to verify them if shortlisted.
            )],
            [:bold, "Volatile markets & last financial year"],
            [:normal, %(
              We recognise that recent volatile market conditions might have affected your growth plans. We will take this into consideration during the assessment process.,

              Also, typically, you would have to submit data for your last financial year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} (the submission deadline). However, if your latest financial performance has been affected by the volatile market conditions due to factors such as Covid, you may wish to use your last financial year before Covid. For example, if your year-end is 31 January 2022, you may want to use the financial year ending 31 January 2020 for your final set of financial figures.
            )],
            [:bold, "Estimated figures"],
            [:normal, %(
              If you are providing figures for the year that falls before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} and haven't reached or finalised your accounts for that year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an external accountant by November. Typically, this would be an external accountant who prepares your annual accounts or returns or, in the case of a larger organisation, who conducts your financial audit.
            )]
          ]
        end

        options :innovation_performance_years, "How would you describe the impact of your innovation on your organisation's financial performance?" do
          classes "js-entry-period"
          ref "C 1"
          required
          context %(
            <p>
              Your answer will determine whether you are assessed for outstanding innovation (over two years) or continuous innovation (over five years).
            </p>
            <p>
              <strong>Outstanding commercial performance</strong> over two years would typically show a level of growth of more than 20% year on year. Please note, this is not a fixed number - there may be exceptions.
            </p>
            <p>
              <strong>Continuous commercial performance</strong> over five years would typically show a consistent level of growth of more than 10% year on year. Please note, this is not a fixed number - there may be exceptions.
            </p>
            <p>
              Please note, the above percentages are indicative, we will consider your specific circumstances. For example, if a business has been in a declining market and the innovation opens new market opportunities. In this instance, sales growth may not be significant, but the turnaround of business potential and safeguarding of jobs may be.
            </p>
          )
          option "2 to 4", "Outstanding Commercial Performance: innovation has improved commercial performance over two years"
          option "5 plus", "Continuous Commercial Performance: innovation has improved commercial performance over five years"
          financial_date_selector({
            "2 to 4" => "2",
            "5 plus" => "5"
          })
          default_option "5 plus"
          sub_category_question
        end

        innovation_financial_year_date :financial_year_date, "Enter your financial year-end date." do
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

        textarea :financial_year_date_changed_explaination, "Please explain why your year-end date changed." do
          classes "sub-question"
          sub_ref "C 2.1.1"
          required
          rows 1
          words_max 100
          conditional :financial_year_date_changed, :yes
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

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")

          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
          conditional :innovation_performance_years, :true
        end

        by_years :employees, "Enter the number of people employed by your organisation in the UK in each year of your entry." do
          classes "question-employee-min"
          ref "C 3"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end or the average for the 12-month period. Part-time employees should be expressed in full-time equivalents.</p>
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
            <h3 class='govuk-heading-m govuk-!-margin-bottom-1'>Group entries</h3>
            <p class='govuk-body'>
              A parent company making a group entry should include the trading figures of all UK members of the group.
            </p>

            <h3 class='govuk-heading-m govuk-!-margin-bottom-1'>Figures - format</h3>
            <p class='govuk-body'>
              You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound, do not enter pennies. Do not separate your figures with commas.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "Group entries"],
            [:normal, %(
              A parent company making a group entry should include the trading figures of all UK members of the group.
            )],
            [:bold, "Figures - format"],
            [:normal, %(
              You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound, do not enter pennies. Do not separate your figures with commas.
            )]
          ]

          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        by_years :total_turnover, "Total turnover." do
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

        by_years :exports, "Of which exports." do
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
        turnover_exports_calculation :uk_sales, "Of which UK sales." do
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

        by_years :net_profit, "Net profit after tax but before dividends (the UK and overseas)." do
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

        by_years :total_net_assets, "Total net assets." do
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

        textarea :drops_in_turnover, "Explain any drops in the total turnover, export sales, total net assets or net profit and any losses made." do
          classes "sub-question"
          sub_ref "C 4.6"
          required
          rows 3
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

        textarea :drops_explain_how_your_business_is_financially_viable, "Explain how your business is financially viable in terms of cash flow, cash generated, and investment received." do
          classes "sub-question"
          sub_ref "C 4.7"
          required
          context %(
            <p>
              We recognise that some innovations have high initial development costs, leading to low or negative profitability in the short term. If this is true for your innovation, please explain your investment strategy, expected outcomes, and expected timescales.
            </p>
            <p>
              If you are an established business and showing low or negative profitability, please explain why and how the business is sustainable and specifically what impact your innovation has on this position.
            </p>
          )
          rows 3
          words_max 300
        end

        textarea :investments_details, "Enter details of all your investments in the innovation. Include all investments made both during and before your entry period. Also, include the years in which they were made." do
          classes "sub-question"
          sub_ref "C 4.8"
          required
          rows 3
          words_max 250
          context %(
            <p>
              This should include both capital purchases, and investments, grants, and loans received, as well as the cost of staff time and other non-cash resources. If relevant, you could also include R&D investment, innovation loans, or Innovate UK grants.
            </p>
          )
        end

        textarea :roi_details, "Please provide calculations on how you have recovered or will recover the investments outlined in question C4.8. How long did it take or will it take to recover the investments?" do
          classes "sub-question"
          sub_ref "C 4.9"
          required
          rows 3
          words_max 250
          context %(
            <p>
              If your innovation is expected to recover its full costs in the future, explain how and when this will happen.
            </p>
          )
        end

        options :innovation_part_of, "How would the innovation that forms the basis of this application fit within the overall business?" do
          ref "C 5"
          required
          option "it's integral to the whole business", "It's integral to the whole business"
          option :single_product_or_service, "It affects a single product/service"
          context %(
            <p>
              It is essential that we understand the value of your innovation in the context of your overall commercial performance. Choose from the following two options.
            </p>
          )
          context_for_option "it's integral to the whole business", %(
            <p>
              Select this option only if your innovation affects all aspects of your business. Examples of where this would be the case are:
            </p>
            <ul>
              <li>A software company that has developed and sells a single application.</li>
              <li>A business that has developed a customer management platform that adds value to every customer interaction.</li>
            </ul>
          )
          context_for_option :single_product_or_service, %(
            <p>
              Select this option if your innovation is embodied within a service or product (or range of products) that forms a part of a broader offering to your customers. If you select this option, you will be asked to enter unit sales and financial data specific to the innovation. This enables assessors to quantify the contribution to overall commercial performance made by the innovation.
            </p>
          )
          pdf_context_for_option "it's integral to the whole business", %(
            Select this option only if your innovation affects all aspects of your business. Examples of where this would be the case are:

            \u2022 A software company that has developed and sells a single application.
            \u2022 A business that has developed a customer management platform that adds value to every customer interaction.
          )
          pdf_context_for_option :single_product_or_service, %(
            Select this option if your innovation is embodied within a service or product (or range of products) that forms a part of a broader offering to your customers. If you select this option, you will be asked to enter unit sales and financial data specific to the innovation. This enables assessors to quantify the contribution to overall commercial performance made by the innovation.
          )
          default_option "it's integral to the whole business"
        end

        textarea :innovation_impact_integral_description, "Explain how, and by how much, your innovation has impacted your commercial performance." do
          classes "sub-question"
          sub_ref "C 5.1"
          required
          conditional :innovation_part_of, "it's integral to the whole business"
          context %(
            <p>
              A couple of examples that may help you answer this question:
            </p>
            <ul>
              <li>Our innovation is the only product sold and generates 100% of revenue. Our business has been built upon this innovation…</li>
              <li>Our customer management platform has increased customer satisfaction ratings by X%, and our customer retention level has risen by Y% since its introduction. This has enabled us to grow our customer base by Z%...</li>
            </ul>
          )
          pdf_context %(
            <p>
              A couple of examples that may help you answer this question:
            </p>
            <p>
              \u2022 Our innovation is the only product sold and generates 100% of revenue. Our business has been built upon this innovation…

              \u2022 Our customer management platform has increased customer satisfaction ratings by X%, and our customer retention level has risen by Y% since its introduction. This has enabled us to grow our customer base by Z%...
            </p>
          )
          rows 2
          words_max 200
        end

        header :product_financials, "Innovation financials" do
          ref "C 6"

          context %(
            <h3 class="govuk-heading-m govuk-!-margin-bottom-1">About C6 questions</h3>
            <p class="govuk-body">
              Some of the details may not apply to your innovation. Answer the questions that are relevant to help us understand the financial value of your innovation.
            </p>

            <h3 class="govuk-heading-m govuk-!-margin-bottom-1">Figures - format</h3>
            <p class="govuk-body">
              You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound, do not enter pennies. Do not separate your figures with commas.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "About C6 questions"],
            [:normal, %(
              Some of the details may not apply to your innovation. Answer the questions that are relevant to help us understand the financial value of your innovation.
            )],
            [:bold, "Figures - format"],
            [:normal, %(
              You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound, do not enter pennies. Do not separate your figures with commas.
            )]
          ]
        end

        by_years :units_sold, "Number of innovative units or contracts sold (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.1"
          type :number
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
        end

        by_years :sales, "Sales of your innovative product/service (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.2"
          type :money
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
        end

        by_years :sales_exports, "Of which exports (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.3"
          context %(<p>Enter '0' if you had none.</p>)
          type :money
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
        end

        by_years :sales_royalties, "Of which royalties or licences (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.4"
          context %(<p>Enter '0' if you had none.</p>)
          type :money
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :innovation_performance_years, "2 to 4", 2
          by_year_condition :innovation_performance_years, "5 plus", 5
        end

        textarea :drops_in_sales, "Explain any drop in sales or the number of units sold (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.5"
          rows 2
          words_max 200
        end

        by_years :avg_unit_price, "Average unit selling price or contract value (if applicable)." do
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

        textarea :avg_unit_price_desc, "Explain your unit selling prices or contract values, highlighting any changes over the above periods (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.7"
          rows 2
          words_max 200
        end

        by_years :avg_unit_cost_self, "Direct cost, to you, of a single unit or contract (if applicable)." do
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

        textarea :costs_change_desc, "Explain your direct unit or contract costs, highlighting any changes over the above periods (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.9"
          rows 2
          words_max 200
        end

        textarea :innovation_performance, "Describe how, when, and to what extent the innovation has improved the commercial performance of your business." do
          ref "C 7"
          required
          context %(
            <p>
              If further improvements are still anticipated, clearly demonstrate how and when in the future they will be delivered. For example, new sales, cost savings, and their overall effect on turnover and profitability, new investment secured, new orders secured.
            </p>
          )
          rows 3
          words_max 250
        end

        textarea :covid_impact_details, "Explain how your business has been responding to volatile markets in recent years." do
          ref "C 8"
          required
          context %(
            <p>
              How have you adapted to or mitigated the impacts of recent volatile markets due to factors such as Covid, and with what results? How are you planning to respond in the year ahead? This could include opportunities you have identified as well as any contextual information or challenges you would like the assessors to consider.
            </p>
          )
          rows 4
          words_max 350
        end

        options :product_estimated_figures, "Are any of the figures used on this page estimates?" do
          ref "C 9"
          yes_no

          context %(
            <p>
              If you haven't reached or finalised your latest year-end yet, it is acceptable to use estimated figures. If you are shortlisted, you will have to provide the actual figures that have been verified by an external accountant by November.
            </p>
          )

          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        textarea :product_estimates_use, "Explain your use of estimates and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "C 9.1"
          rows 2
          words_max 200
          conditional :product_estimated_figures, :yes
          conditional :innovation_performance_years, :true
          conditional :financial_year_date_changed, :true
        end
      end
    end
  end
end
