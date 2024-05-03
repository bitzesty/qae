class AwardYears::V2022::QaeForms
  class << self
    def mobility_step3
      @mobility_step3 ||= proc do
        header :commercial_success_info_block, "" do
          section_info
          context %(
            <h3 class="govuk-heading-m">About this section</h3>
            <p class="govuk-body">
              All applicants for any Queen’s Award must demonstrate financial sustainability.
            </p>
            <h3 class="govuk-heading-m">Small organisations</h3>
            <p class="govuk-body">
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
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
              All applicants for any Queen’s Award must demonstrate financial sustainability.
            )],
            [:bold, "Small organisations"],
            [:normal,
             %(
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
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

        textarea :commercial_performance_description, "How would you describe your organisation's financials?" do
          sub_ref "C 1"
          required
          context %(
            <p>To be eligible for a Queen’s Award for Enterprise, your organisation must be on a sustainable financial footing.</p>
          )
          rows 5
          words_max 250
        end

        innovation_financial_year_date :financial_year_date, "Enter your financial year-end date." do
          ref "C 2"
          required
          financial_date_pointer
          context "<p>You will have to submit data for your latest financial year that falls before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_time} (the submission deadline). If you haven't reached or finalised your latest year-end yet, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.</p>"
        end

        options :financial_year_date_changed, "Did your year-end date change in the last three-years?" do
          classes "sub-question js-financial-year-change"
          sub_ref "C 2.1"
          required
          yes_no
          default_option "no"
        end

        one_option_by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question one-option-by-years"
          sub_ref "C 2.2"
          required
          context %(
            <p>Typically, you would have to submit data for your latest financial year that falls before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_time} (the submission deadline). However, if your current financial year's performance has been affected by the spread of COVID-19, you may wish to consider using your previous year as the latest year. For example, if your year-end is 31 May 2021 you may want to use the financial year ending 31 May 2020 for your final set of financial figures.</p>

            <p>If you haven't reached or finalised your accounts for the latest year, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.</p>
          )
          type :date
          label ->(y) { "Financial year #{y}" }
        end

        textarea :financial_year_date_changed_explaination, "Please explain why your year-end date changed." do
          classes "sub-question"
          sub_ref "C 2.3"
          required
          rows 5
          words_max 50
          conditional :financial_year_date_changed, :yes
        end

        one_option_by_years :employees, "Enter the number of people employed by your organisation in the UK in each year of your entry." do
          ref "C 3"
          classes "question-employee-min"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the twelve-month period. Part-time employees should be expressed in full-time equivalents (FTEs).</p>
          )
          type :number
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true
          employees_question
        end

        header :financials, "Financials" do
          ref "C 4"
          context %(
            <h3 class="govuk-heading-m govuk-!-margin-bottom-1">Group entries</h3>
            <p class="govuk-body">A parent organisation making a group entry should include figures of all UK members of the group.</p>

            <h3 class="govuk-heading-m govuk-!-margin-bottom-1">Estimated figures</h3>
            <p class="govuk-body">If you haven't reached or finalised your latest year-end yet, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.</p>

            <h3 class="govuk-heading-m govuk-!-margin-bottom-1">Figures - format</h3>
            <p class="govuk-body">You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound (do not enter pennies). Do not separate your figures with commas.</p>
          )
          pdf_context_with_header_blocks [
            [:bold, "Group entries"],
            [:normal,
             %(
              A parent organisation making a group entry should include figures of all UK members of the group.
            )],
            [:bold, "Estimated figures"],
            [:normal,
             %(
              If you haven't reached or finalised your latest year-end yet, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            )],
            [:bold, "Figures - format"],
            [:normal,
             %(
              You must enter financial figures in pounds sterling (£). Round the figures to the nearest pound (do not enter pennies). Do not separate your figures with commas.
            )],
          ]
        end

        one_option_by_years :total_turnover, "Total income or turnover" do
          classes "sub-question"
          ref "C 4.1"
          required
          context %(
            <p>If you are a charity, please provide your total income figures; if you are a company, please provide your turnover figures.</p>
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
          )

          type :money
          label ->(y) { "Financial year #{y}" }
        end

        one_option_by_years :net_profit, "Net income or net profit after tax but before dividends" do
          classes "sub-question"
          sub_ref "C 4.2"
          required
          context %(
            <p>If you are a charity, please provide your net income figures; if you are a company, please provide your net profit after tax but before dividends figures.</p>
            <p>Use a minus symbol to record any losses.</p>
          )

          type :money
          label ->(y) { "Financial year #{y}" }
        end

        one_option_by_years :total_net_assets, "Total net assets" do
          classes "sub-question total-net-assets"
          sub_ref "C 4.3"
          required
          context "<p>As per your balance sheet. Total assets (fixed and current), minus liabilities (current and long-term).</p>"
          type :money
          label ->(y) { "As at the end of year #{y}" }
        end

        textarea :drops_in_turnover,
                 "Explain any drops in the total income or turnover, net income or net profit and total net assets and any losses made." do
          classes "sub-question"
          sub_ref "C 4.4"
          required
          context %(
            <p>Sustained or unexplained drops or losses may lead to the entry being rejected.</p>
            <p>Answer this question if you have any dips or losses in total income/turnover, net income/profits or total net assets. If you didn't have any drops or losses, please state so.</p>
          )
          rows 5
          words_max 300
        end

        textarea :drops_explain_how_your_business_is_financially_viable, "Explain how your organisation is financially viable." do
          classes "sub-question"
          sub_ref "C 4.5"
          required
          context %(
            <p>For example, explain:</p>
            <ul>
              <li>How you are funded;</li>
              <li>If you have received any form of investment or funding, if so, please specify the amounts;</li>
              <li>How you plan to sustain your organisation in future (if you have an investment or funding strategy, please set out its objectives).</li>
            </ul>
            <p>This information is particularly useful when ascertaining your company’s financial viability, especially when you have drops in total turnover and losses.</p>
          )
          pdf_context %(
            For example, explain:

            \u2022 How you are funded;

            \u2022 If you have received any form of investment or funding, if so, please specify the amounts;

            \u2022 How you plan to sustain your organisation in future (if you have an investment or funding strategy, please set out its objectives).

            This information is particularly useful when ascertaining your company’s financial viability, especially when you have drops in total turnover and losses.
          )
          rows 5
          words_max 300
        end

        options :product_estimated_figures, "Are any of the figures used on this page estimates?" do
          ref "C 5"
          required
          context %(
            <p>If you haven't reached or finalised your latest year-end yet, it is acceptable to use estimated figures. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.</p>
          )
          yes_no
        end

        textarea :product_estimates_use, "Explain the use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "C 5.1"
          required
          rows 5
          words_max 250
          conditional :product_estimated_figures, :yes
        end

        textarea :covid_impact,
                 "Describe the impact COVID-19 has had on your business and its performance. How you have adapted or mitigated it, and with what results?" do
          sub_ref "C 6"
          required
          rows 5
          words_max 300
        end
      end
    end
  end
end
