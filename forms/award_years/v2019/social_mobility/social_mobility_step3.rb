class AwardYears::V2019::QaeForms
  class << self
    def mobility_step3
      @mobility_step3 ||= proc do
        header :commercial_success_info_block, "" do
          context %(
            <p>
              All applicants for any Queen’s Award must demonstrate a certain level of financial performance. This section enables you to demonstrate the impact that your social mobility programme(s) had on your organisation's financial performance.
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

        textarea :commercial_performance_description, "How would you describe your organisation's financial performance?" do
          sub_ref "C 1"
          required
          context %(
            <p>
              To be eligible for a Queen’s Award for Enterprise, your business must be on a sustainable financial footing. You are therefore required to demonstrate this by providing three years financial growth figures that cover the period your social mobility programme has been running.
            </p>
          )
          rows 5
        end

        innovation_financial_year_date :financial_year_date, "Enter your financial year-end date." do
          ref "C 2"
          required
          context %(
            <p>If you haven't reached or finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application. If shortlisted, these figures will need to be verified by an independent accountant within a specified deadline.</p>
          )
          financial_date_pointer
        end

        options :financial_year_date_changed, "Did your year-end date change during the three-year entry period?" do
          classes "sub-question js-financial-year-change"
          sub_ref "C 2.1"
          required
          yes_no
          context %(
            <p>
              We ask this to obtain all the commercial figures we need to assess your application. You should ensure that any data supporting your application covers three full twelve-month periods.
            </p>
          )
          default_option "no"
        end

        one_option_by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question"
          sub_ref "C 2.2"
          required
          type :date
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :yes
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
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the twelve-month period. Part-time employees should be expressed in full-time equivalents.</p>
          )
          type :number
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true

          employees_question
        end

        header :company_financials, "Company Financials" do
          ref "C 4"
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
              <u>Please do not separate your figures with commas.</u>
            </p>
          )
        end

        one_option_by_years :total_turnover, "Total turnover" do
          classes "sub-question"
          ref "C 4.1"
          required
          context %(
            <p>
              If you haven't reached your latest year-end, please use estimates to complete this question.
            </p>
          )

          type :money
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        one_option_by_years :net_profit, "Net profit after tax but before dividends (UK and overseas)" do
          classes "sub-question"
          sub_ref "C 4.2"
          required
          context %(
            <p>
              Use a minus symbol to record any losses.
            </p>
          )

          type :money
          label ->(y) { "Financial year #{y}" }
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        one_option_by_years :total_net_assets, "Total net assets" do
          classes "sub-question total-net-assets"
          sub_ref "C 4.3"
          required
          context %(
            <p>
              As per your balance sheet. Total assets (fixed and current), minus liabilities (current and long-term).
            </p>
          )
          type :money
          label ->(y) { "As at the end of year #{y}" }

          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover, "Explain any drops in turnover, total net assets and net profits, as well as any losses made." do
          classes "sub-question js-conditional-drop-question"
          sub_ref "C 4.4"
          rows 5
          words_max 100
          conditional :financial_year_date_changed, :true
          drop_condition_parent
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

        textarea :investments_details, "Please enter details of all investments and reinvestments (capital and operating costs) in your social mobility programme." do
          ref "C 6"
          required
          context %(
            <p>
              Include all investments and reinvestments made both during and prior to your entry period. Also, include the year(s) in which they were made.
            </p>
          )
          rows 5
          words_max 400
        end
      end
    end
  end
end
