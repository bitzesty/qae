class AwardYears::V2020::QaeForms
  class << self
    def development_step3
      @development_step3 ||= proc do
        header :commercial_success_info_block, "" do
          context %(
            <h3>About this section</h3>
            <p>
              To be eligible for a Queen's Awards for Enterprise, your business must be financially viable. You are required to demonstrate this by providing three years of financial growth figures that cover the period your sustainable development actions or interventions have been in place.
            </p>

            <h3>Small organisations</h3>
            <p>
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            </p>

            <h3>Estimated figures</h3>
            <p>
              You will have to submit data for your latest financial year that falls before the <strong>#{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_time}</strong> (the submission deadline). If you haven't reached or finalised your latest year-end yet, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
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
            [:bold, "Estimated figures"],
            [:normal,
             %(
              You will have to submit data for your latest financial year that falls before the <strong>#{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_time}</strong> (the submission deadline). If you haven't reached or finalised your latest year-end yet, you can provide estimated figures for now. If you are shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
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
          context %(
            <p>If you haven't reached or finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application. If shortlisted, these figures will need to be verified by an independent accountant within a specified deadline.</p>
          )
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
            <p>
              A parent company making a group entry should include the trading figures of all UK members of the group.
            </p>
            <p>
              You must enter actual financial figures in £ sterling (ignoring pennies).
            </p>
            <p>
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
          drop_conditional :drops_in_turnover
        end

        one_option_by_years :exports, "Of which exports" do
          classes "sub-question"
          sub_ref "C 4.2"
          required
          context %(<p>Please enter '0' if you had none.</p>)

          type :money
          label ->(y) { "Financial year #{y}" }

          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
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
          drop_conditional :drops_in_turnover
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
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover,
                 "Explain any drops in turnover, export sales, total net assets and net profits, as well as any losses made." do
          classes "sub-question js-conditional-drop-question"
          sub_ref "C 4.6"
          rows 5
          words_max 200

          conditional :financial_year_date_changed, :true
          drop_condition_parent
        end

        options :entry_relates_to,
                "How do your sustainable development actions or interventions, that form the basis of this application, fit within the overall business?" do
          ref "C 5"
          required
          option :entire_business, "It's integral to the whole business"
          option :single_product_or_service, "It affects specific sustainable development actions or intervention"
          context %(
            <p>
              It is important that we know whether or not your sustainable development is the key thing your business does or forms part of a wider approach. This is so we can understand the commercial value of your sustainable development in the context of your overall commercial performance.
            </p>
          )
        end

        header :product_financials, "Sustainable Development Financials" do
          ref "C 6"
          context %(
            <p>If applicable, please provide your unit price, cost details and sales figures  to help us understand the value of your sustainable development.</p>

            <p>Some questions may not apply, please answer the ones that are applicable to your sustainable development.</p>

            <p>You must enter actual financial figures in £ sterling (ignoring pennies).</p>

            <p>Please do not separate your figures with commas.</p>
          )
        end

        one_option_by_years :units_sold, "Number of units/contracts sold (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.1"
          type :number
          label "..."
        end

        one_option_by_years :sales, "Sales (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.2"
          type :money
          label "..."
        end

        one_option_by_years :sales_exports, "Of which exports (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.3"
          context %(<p>Please enter '0' if you had none.</p>)
          type :money
          label "..."
        end

        one_option_by_years :sales_royalties, "Of which royalties or licences (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.4"
          context %(<p>Please enter '0' if you had none.</p>)
          type :money
          label "..."
        end

        textarea :drops_in_sales, "Explain any drop in sales or number of units sold (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.5"
          rows 5
          words_max 250
        end

        one_option_by_years :avg_unit_cost_self, "Direct cost, to you, of a single unit/contract (if applicable)" do
          sub_ref "C 6.6"
          classes "sub-question"
          type :money
          label "..."
        end

        textarea :costs_change_desc,
                 "Explain your direct unit/ contract costs, highlighting any changes over the above periods (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.7"
          rows 5
          words_max 250
        end

        options :product_estimated_figures, "Are any of the figures used on this page estimates?" do
          ref "C 7"
          required
          yes_no

          conditional :financial_year_date_changed, :true
        end

        textarea :product_estimates_use, "Explain the use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "C 7.1"
          required
          rows 5
          words_max 250
          conditional :product_estimated_figures, :yes
        end

        textarea :development_performance,
                 "What cost-savings have you or your customers' businesses made as a result of the introduction of your sustainable development actions or interventions?" do
          ref "C 8"
          required
          context %(
            <p>
              Please describe the cost savings and/or other benefits in addition to the sustainability impact you have already demonstrated in section B of this form. Please provide figures, if known.
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :investments_details,
                 "Please enter details of all investments and reinvestments (capital and operating costs) in your sustainable development actions or interventions." do
          ref "C 9"
          required
          context %(
            <p>
              Include all investments and reinvestments made both during and before your entry period. Also, include the year(s) in which they were made.
            </p>
          )
          rows 5
          words_max 400
        end

        textarea :roi_details, "How long did it take you to break even? When and how was this achieved?" do
          sub_ref "C 9.1"
          classes "sub-question"
          required
          context %(
            <p>
              'Breaking even' is when you reach a point where profits are equal to all costs (capital and operating).
            </p>
          )
          rows 5
          words_max 250
        end
      end
    end
  end
end
