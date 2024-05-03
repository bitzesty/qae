class AwardYears::V2022::QaeForms
  class << self
    def development_step3
      @development_step3 ||= proc do
        header :commercial_success_info_block, "" do
          section_info
          context %(
            <h3 class="govuk-heading-m">About this section</h3>
            <p class="govuk-body">
              To be eligible for a Queen's Awards for Enterprise, your business must be financially viable. You are required to demonstrate this by providing three years of financial growth figures that cover the period your sustainable development actions or interventions have been in place.
            </p>

            <h3 class="govuk-heading-m">Small organisations</h3>
            <p class="govuk-body">
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            </p>

            <h3 class="govuk-heading-m">COVID-19 impact</h3>
            <p class="govuk-body">
              We recognise that Covid-19 might have affected your growth plans and will take this into consideration during the assessment process.
            </p>

            <h3 class="govuk-heading-m">Latest financial year and COVID-19</h3>
            <p class="govuk-body">
              Typically, you would have to submit data for your latest financial year that falls before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_time} (the submission deadline). However, if your current financial year's performance has been affected by the spread of COVID-19, you may wish to consider using your previous year as the latest year. For example, if your year-end is 31 May 2021 you may want to use the financial year ending 31 May 2020 for your final set of financial figures.
            </p>
            <h3 class="govuk-heading-m">Estimated figures</h3>
            <p class="govuk-body">
              If you haven't reached or finalised your accounts for the latest year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "About this section"],
            [:normal,
             %(
              To be eligible for a Queen's Awards for Enterprise, your business must be financially viable. You are required to demonstrate this by providing three years of financial growth figures that cover the period your sustainable development actions or interventions have been in place.
            )],
            [:bold, "Small organisations"],
            [:normal,
             %(
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            )],
            [:bold, "COVID-19 impact"],
            [:normal,
             %(
              We recognise that Covid-19 might have affected your growth plans and will take this into consideration during the assessment process.
            )],
            [:bold, "Latest financial year and COVID-19"],
            [:normal,
             %(
              Typically, you would have to submit data for your latest financial year that falls before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_time} (the submission deadline). However, if your current financial year's performance has been affected by the spread of COVID-19, you may wish to consider using your previous year as the latest year. For example, if your year-end is 31 May 2021 you may want to use the financial year ending 31 May 2020 for your final set of financial figures.
            )],
            [:bold, "Estimated figures"],
            [:normal,
             %(
              If you haven't reached or finalised your accounts for the latest year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            )],
          ]
        end

        textarea :explain_why_your_organisation_is_financially_viable, "Explain why your organisation is financially viable." do
          ref "C 1"
          required
          context %(
            <p>
              For example, you could briefly explain your financial model, income or profit growth, how you are funded, your cash flow position and investments secured. Some of these may not apply to your organisation, in that case, explain by what other means your organisation ensures financial viability.
            </p>
          )
          rows 5
          words_max 250
        end

        innovation_financial_year_date :financial_year_date, "Please enter your financial year end date." do
          ref "C 2"
          required
          financial_date_pointer
        end

        options :financial_year_date_changed,
                "Did your year-end date change during your <span class='js-entry-period-subtext'>3</span> year entry period?" do
          classes "sub-question js-financial-year-change"
          sub_ref "C 2.1"
          required
          yes_no
          context %(
            <p>
              We ask this to obtain all of the commercial figures we need to assess your application. You should ensure that any data supporting your application covers <span class='js-entry-period-subtext'>3</span> full 12-month periods.
            </p>
          )
          default_option "no"
        end

        one_option_by_years_label :financial_year_changed_dates, "Please enter your year-end dates for each financial year." do
          classes "sub-question one-option-by-years"
          sub_ref "C 2.2"

          context %(
            <p>
              Typically, you would have to submit data for your latest financial year that falls before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_time} (the submission deadline). However, if your current financial year's performance has been affected by the spread of COVID-19, you may wish to consider using your previous year as the latest year. For example, if your year-end is 31 May 2021 you may want to use the financial year ending 31 May 2020 for your final set of financial figures.
            </p>
            <p>
              If you haven't reached or finalised your accounts for the latest year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            </p>
          )

          required
          type :date
          label ->(y) { "Financial year #{y}" }
        end

        textarea :financial_year_date_changed_explaination, "Please explain why your year-end date changed." do
          classes "sub-question"
          sub_ref "C 2.3"
          required
          rows 5
          words_max 100
          conditional :financial_year_date_changed, :yes
        end

        one_option_by_years :employees, "Enter the number of people employed by your organisation in the UK in each year of your entry." do
          classes "question-employee-min"
          ref "C 3"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. </p>
          )
          type :number
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true

          employees_question
        end

        header :company_financials, "Company Financials" do
          ref "C 4"
          context %(
            <p class="govuk-body">
              A parent company making a group entry should include the trading figures of all UK members of the group.
            </p>
            <p class="govuk-body">
              You must enter actual financial figures in £ sterling (ignoring pennies).
            </p>
            <p class="govuk-body">
              Please do not separate your figures with commas.
            </p>
          )
        end

        one_option_by_years :total_turnover, "Total turnover" do
          ref "C 4.1"
          required
          classes "sub-question"

          type :money
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true
        end

        one_option_by_years :exports, "Of which exports" do
          classes "sub-question"
          sub_ref "C 4.2"
          required
          context %(<p>Please enter '0' if you had none.</p>)

          type :money
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true
        end

        # UK sales = turnover - exports
        turnover_exports_calculation :uk_sales, "Of which UK sales" do
          classes "sub-question"
          sub_ref "C 4.3"
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true
          turnover :total_turnover
          exports :exports
          one_option_financial_data_mode true

          context %(
            <p>
              This number is automatically calculated using your total turnover and export figures.
            </p>
          )
        end

        one_option_by_years :net_profit, "Net profit after tax but before dividends (UK and overseas)" do
          classes "sub-question"
          sub_ref "C 4.4"
          required

          type :money
          label ->(y) { "Financial year #{y}" }

          context %(
            <p>
              Use a minus symbol to record any losses.
            </p>
          )

          conditional :financial_year_date_changed, :true
        end

        one_option_by_years :total_net_assets, "Total net assets" do
          classes "sub-question total-net-assets"
          sub_ref "C 4.5"
          required
          context %(
            <p>
              As per your balance sheet. Total assets (fixed and current) minus liabilities (current and long-term).
            </p>
          )
          type :money
          label ->(y) { "As at the end of year #{y}" }

          conditional :financial_year_date_changed, :true
        end

        textarea :drops_in_turnover,
                 "Explain any drops in turnover, export sales, total net assets and net profits, as well as any losses made." do
          classes "sub-question"
          sub_ref "C 4.6"
          required
          rows 5
          words_max 200

          context %(
            <p>
              If you didn't have any drops in the total turnover, export sales, total net assets or net profit, or any losses, please state so.
            </p>
          )
        end

        options :product_estimated_figures, "Are any of the figures used on this page estimates?" do
          ref "C 5"
          required
          yes_no

          conditional :financial_year_date_changed, :true
        end

        textarea :product_estimates_use, "Explain the use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "C 5.1"
          required
          rows 5
          words_max 250
          conditional :product_estimated_figures, :yes
        end

        textarea :development_performance,
                 "What cost-savings have you or your customers’ businesses made or will make as a result of the introduction of your sustainable development actions or interventions? If none, please state so." do
          ref "C 6"
          required
          context %(
            <p>
              Provide figures and describe cost-savings and other benefits in addition to the sustainability impact you have already demonstrated in section B of this form.
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :investments_details,
                 "Please enter details of all investments and reinvestments (capital and operating costs) in your sustainable development actions or interventions. If none, please state so." do
          ref "C 7"
          required
          context %(
            <p>
              Include all investments and reinvestments made both during and before your entry period. Also, include the year(s) in which they were made.
            </p>
          )
          rows 5
          words_max 400
        end

        textarea :covid_19_impact,
                 "Describe the impact COVID-19 has had on your business and its performance. How you have adapted or mitigated it, and with what results?" do
          ref "C 8"
          required
          rows 5
          words_max 400
        end
      end
    end
  end
end
