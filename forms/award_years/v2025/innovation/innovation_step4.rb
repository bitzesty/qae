# -*- coding: utf-8 -*-
class AwardYears::V2025::QaeForms
  class << self
    def innovation_step4
      @innovation_step4 ||= proc do
        about_section :commercial_success_info_block, "" do
          section "innovation_commercial_performance"
        end

        innovation_financial_year_date :financial_year_date, "Enter your financial year-end date." do
          ref "D 1"
          classes "fs-trackable fs-two-trackable"
          required
          financial_date_pointer
        end

        trade_most_recent_financial_year_options :most_recent_financial_year, "Which year would you like to be your most recent financial year that you will submit figures for?" do
          ref "D 1.1"
          required
          option (AwardYear.current.year - 2).to_s, (AwardYear.current.year - 2).to_s
          option (AwardYear.current.year - 1).to_s, (AwardYear.current.year - 1).to_s
          default_option (AwardYear.current.year - 1).to_s

          classes "js-most-recent-financial-year fs-trackable fs-two-trackable"
          context %(
            <p>
              Answer this question if your dates in question D1 range between #{Settings.current_award_year_switch_date.decorate.formatted_trigger_date} to #{Settings.current_submission_deadline.decorate.formatted_trigger_date}.
            </p>
          )

          conditional :financial_year_date, :day_month_range, range: AwardYear.fy_date_range_threshold(minmax: true), disable_pdf_conditional_hints: true, data: {value: AwardYear.fy_date_range_threshold(minmax: true, format: true), type: :range}
        end

        options :financial_year_date_changed, "Did your year-end date change during your <span class='js-entry-period-subtext'>five</span> most recent financial years that you will be providing figures for?" do
          classes "sub-question js-financial-year-change fs-trackable fs-two-trackable"
          sub_ref "D 2"
          context %(
            <p>
              If you started trading within the last five years, answer if your year-end date has changed since you started trading.
            </p>
          )
          required
          yes_no
          default_option "no"
        end

        by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question fs-year-end fs-trackable fs-two-trackable"
          sub_ref "D 2.1"
          required
          type :date
          label ->(y) { "Financial year #{y}" }

          context %(
            <p>
              We recommend that you answer question B5 before proceeding with this and further questions, as this will automatically adjust the number of years you need to provide the figures for.
            </p>
            <p>
              For the purpose of this application, your most recent financial year-end is your last financial year ending before the #{Settings.current_submission_deadline.decorate.formatted_trigger_date('with_year')} - the application submission deadline.
            </p>
          )

          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true
          conditional :financial_year_date_changed, :yes
        end

        textarea :adjustments_explanation, "Explain adjustments to figures." do
          classes "sub-question"
          sub_ref "D 2.2"
          required
          rows 2
          words_max 200
          context %(
            <p>
              If your financial year-end has changed, you will need to agree with your accountants on how to allocate your figures so that they equal 12-month periods. This allows for a comparison between years.
            </p>
            <p>
              Please explain what approach you will take to adjust the figures.
            </p>
          )
          conditional :financial_year_date_changed, :yes
        end

        textarea :financial_year_date_changed_explaination, "Explain why your year-end date changed." do
          classes "sub-question"
          sub_ref "D 2.3"
          required
          rows 1
          words_max 100
          conditional :financial_year_date_changed, :yes
        end

        by_years :employees, "Enter the number of people employed by your organisation in the UK." do
          classes "question-employee-min"
          ref "D 3"
          required
          context %(
            <p>We recommend that you answer question B5 before proceeding with this and further questions, as this will automatically adjust the number of years you need to provide the figures for.</p>

            <p>You can use the number of full-time employees at the year-end or the average for the 12-month period. Part-time employees should be expressed in full-time equivalents (FTEs).</p>

            <p>If you started trading within the last five years, you only need to provide numbers for the years you have been trading. However, to meet minimum eligibility requirements, you must be able to provide employee numbers for at least your two most recent financial years, covering the full 24 months.</p>

            <p>If your organisation is based in the Channel Islands or Isle of Man, you should include only the employees who are located there (do not include employees who are in the UK).</p>

            <p>Enter '0' if you had none.</p>
          )
          type :number
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true
          conditional :financial_year_date_changed, :true
          employees_question
          validatable_years_position [-2..-1] # validate only last 2 years for employee min. threshold
        end

        about_section :company_financials, "Company Financials" do
          ref "D 4"
          section "company_financials_innovation"
          conditional :financial_year_date_changed, :true
        end

        by_years :total_turnover, "Total turnover." do
          ref "D 4.1"
          required
          classes "sub-question fs-total-turnover fs-trackable"
          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true
          conditional :financial_year_date_changed, :true
        end

        by_years :exports, "Of which exports." do
          classes "sub-question fs-exports fs-trackable"
          sub_ref "D 4.2"
          required
          context %(
            <p>If your organisation is based in the Channel Islands or Isle of Man, any sales to the UK should be counted as exports. Likewise, a UK-based organisation's sales to the Channel Islands or Isle of Man should be counted as exports.</p>

            <p>Please enter '0' if you had none. If you don't have exact export figures, you can provide approximate ones.</p>
          )
          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true
          conditional :financial_year_date_changed, :true
        end

        # UK sales = turnover - exports
        turnover_exports_calculation :uk_sales, "Of which UK sales." do
          classes "sub-question fs-uk-sales"
          sub_ref "D 4.3"
          context %(
            <p>This number is automatically calculated using your total turnover and export figures.</p>

            <p>If your organisation is based in the Channel Islands or Isle of Man, these will be your local sales.</p>
          )
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true

          conditional :financial_year_date_changed, :true
          turnover :total_turnover
          exports :exports
        end

        by_years :net_profit, "Net profit after tax but before dividends (the UK and overseas)." do
          classes "sub-question fs-net-profit fs-trackable"
          sub_ref "D 4.4"
          required

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true
          context %(
            <p>
              Use a minus symbol to record any losses.
            </p>
          )
          conditional :financial_year_date_changed, :true
        end

        by_years :total_net_assets, "Total net assets." do
          classes "sub-question total-net-assets fs-total-assets fs-trackable"
          sub_ref "D 4.5"
          required
          context %(
            <p>
              As per your balance sheet. Total assets (fixed and current) minus liabilities (current and long-term).
            </p>
          )

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true

          conditional :financial_year_date_changed, :true
        end

        textarea :drops_in_turnover, "Explain any losses, drops in the total turnover, export sales, total net assets or reductions in net profit." do
          classes "sub-question"
          sub_ref "D 4.6"
          required
          rows 3
          words_max 300
          context %(
            <p>
              Sustained or unexplained drops or losses may lead to the entry being rejected.
            </p>
            <p>
              If you didn't have any losses, drops in the total turnover, export sales, total net assets or reductions in net profit, please state so.
            </p>
          )
        end

        textarea :drops_explain_how_your_business_is_financially_viable, "Explain how your business is financially viable in terms of cash flow, cash generated, and investment received." do
          classes "sub-question"
          sub_ref "D 4.7"
          required
          context %(
            <p>
              We recognise that some innovations have high initial development costs, leading to low or negative profitability in the short term. If this is true for your innovation, please explain your investment strategy, expected outcomes, and expected timescales.
            </p>
            <p>
              If you are an established business and showing low or negative profitability, please explain why and how the business is sustainable and, specifically, what impact your innovation has on this position.
            </p>
          )
          rows 3
          words_max 300
        end

        textarea :investments_details, "Enter details of all your investments in the innovation. Include all investments made both during and before your entry period. Also, include the years in which they were made." do
          classes "sub-question"
          sub_ref "D 4.8"
          required
          rows 3
          words_max 250
          context %(
            <p>
              This should include both capital purchases, and investments, grants, and loans received, as well as the cost of workforce time and other non-cash resources. If relevant, you could also include R&D investment, innovation loans, or Innovate UK grants.
            </p>
          )
        end

        textarea :roi_details, "Please provide calculations on how you have recovered or will recover the investments outlined in question D4.8. How long did it take or will it take to recover the investments?" do
          classes "sub-question"
          sub_ref "D 4.9"
          required
          rows 3
          words_max 250
          context %(
            <p>
              If your innovation is expected to recover its full costs in the future, explain how and when this will happen.
            </p>
          )
        end

        financial_summary :innovation_financial_summary_one, "Summary of your company financials (for information only)" do
          sub_ref "D 4.10"
          partial "innovation_part_1"
        end

        options :innovation_part_of, "How would the innovation that forms the basis of this application fit within the overall business?" do
          ref "D 5"
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

        about_section :product_financials, "Innovation financials" do
          section "innovation_financials"
          ref "D 6"
        end

        by_years :units_sold, "Number of innovative units or contracts sold (if applicable)." do
          classes "sub-question fs-two-units-sold fs-two-trackable"
          sub_ref "D 6.1"
          required
          section :innovation_financials
          context %(
            <p>
              We recommend that you answer question C2.2 before proceeding with this and further questions, as this will automatically adjust the number of years you need to provide the figures for.
            </p>
            <p>Enter '0' if you had none.</p>
          ).squish
          type :number
          label ->(y) { "Financial year #{y}" }

          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true
        end

        by_years :sales, "Sales of your innovative product/service (if applicable)." do
          classes "sub-question fs-two-innovation-sales fs-two-trackable"
          sub_ref "D 6.2"
          required
          section :innovation_financials
          context %(<p>Enter '0' if you had none.</p>)
          type :money
          label ->(y) { "Financial year #{y}" }

          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true
        end

        by_years :sales_exports, "Of which exports (if applicable)." do
          classes "sub-question fs-two-exports fs-two-trackable"
          sub_ref "D 6.3"
          required
          section :innovation_financials
          context %(<p>Enter '0' if you had none.</p>)
          type :money
          label ->(y) { "Financial year #{y}" }

          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true
        end

        by_years :sales_royalties, "Of which royalties or licences (if applicable)." do
          classes "sub-question fs-two-royalties fs-two-trackable"
          sub_ref "D 6.4"
          required
          section :innovation_financials
          context %(<p>Enter '0' if you had none.</p>)
          type :money
          label ->(y) { "Financial year #{y}" }

          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true
        end

        textarea :drops_in_sales, "Explain any drop in sales or the number of units sold (if applicable)." do
          classes "sub-question"
          sub_ref "D 6.5"
          section :innovation_financials
          rows 2
          words_max 200
        end

        by_years :avg_unit_price, "Average unit selling price or contract value (if applicable)." do
          classes "sub-question fs-two-average-unit-price fs-two-trackable"
          sub_ref "D 6.6"
          required
          section :innovation_financials
          context %(
            <p>
              If your innovation is a product, you must provide the unit price.
            </p>
            <p>Enter '0' if you had none.</p>
          ).squish

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true
        end

        textarea :avg_unit_price_desc, "Explain your unit selling prices or contract values, highlighting any changes over the above periods (if applicable)." do
          classes "sub-question"
          sub_ref "D 6.7"
          section :innovation_financials
          rows 2
          words_max 200
        end

        by_years :avg_unit_cost_self, "Direct cost, to you, of a single unit or contract (if applicable)." do
          classes "sub-question fs-two-direct-cost fs-two-trackable"
          sub_ref "D 6.8"
          required
          section :innovation_financials
          context %(
            <p>If you haven't reached your latest year-end, use estimates to complete this question.</p>
            <p>Enter '0' if you had none.</p>
          ).squish
          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :innovation_was_launched_in_the_market, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 250)) }, 5, data: {value: AwardYear.start_trading_between(5, 250, minmax: true, format: true), type: :range, identifier: "5 plus", default: true}, default: true
        end

        textarea :costs_change_desc, "Explain your direct unit or contract costs, highlighting any changes over the above periods (if applicable)." do
          classes "sub-question"
          sub_ref "D 6.9"
          section :innovation_financials
          rows 2
          words_max 200
        end

        financial_summary :innovation_financial_summary_two, "Summary of your company financials (for information only)" do
          partial "innovation_part_2"
          sub_ref "D 6.10"
        end

        textarea :innovation_performance, "Describe how, when, and to what extent the innovation has improved the commercial performance of your business." do
          ref "D 7"
          required
          context %(
            <p>
              You must demonstrate that your innovation positively impacted your commercial success (in terms of turnover or profitability) over at least the last two years.
            </p>
            <p>
              This may include new sales and orders secured, cost savings, and their overall effect on turnover and profitability, as well as new investments secured.
            </p>
            <p>
              A couple of examples that may help you answer this question:
              <ul>
                <li>Our innovation is the only product sold and generates 100% of revenue. Our business has been built upon this innovation...</li>
                <li>Our customer management platform has increased customer satisfaction ratings by X%, and our customer retention level has risen by Y% since its introduction. This has enabled us to grow our customer base by Z%...</li>
              </ul>
            </p>
            <p>
              If further improvements are still anticipated, clearly demonstrate how and when they will be delivered.
            </p>
          )
          pdf_context %(
            You must demonstrate that your innovation positively impacted your commercial success (in terms of turnover or profitability) over at least the last two years.

            This may include new sales and orders secured, cost savings, and their overall effect on turnover and profitability, as well as new investments secured.

            A couple of examples that may help you answer this question:

            \u2022 Our innovation is the only product sold and generates 100% of revenue. Our business has been built upon this innovation...
            \u2022 Our customer management platform has increased customer satisfaction ratings by X%, and our customer retention level has risen by Y% since its introduction. This has enabled us to grow our customer base by Z%...

            If further improvements are still anticipated, clearly demonstrate how and when they will be delivered.
          )
          rows 3
          words_max 250
        end

        textarea :covid_impact_details, "Explain how your business has been responding to the economic uncertainty experienced nationally and globally in recent years." do
          ref "D 8"
          required
          context %(
            <ul>
              <li>How have you adapted to or mitigated the impacts of recent adverse national and global events such as COVID-19, the war in Ukraine, flooding, or wildfires?</li>
              <li>How are you planning to respond in the year ahead? This could include opportunities you have identified.</li>
              <li>Provide any contextual information or challenges you would like the assessors to consider.</li>
            </ul>
          )
          pdf_context %(
            \u2022 How have you adapted to or mitigated the impacts of recent adverse national and global events such as COVID-19, the war in Ukraine, flooding, or wildfires?
            \u2022 How are you planning to respond in the year ahead? This could include opportunities you have identified.
            \u2022 Provide any contextual information or challenges you would like the assessors to consider.
          )
          rows 4
          words_max 350
        end

        options :innovations_grant_funding, "Have you received any grant funding or made use of any other government support?" do
          classes "sub-question"
          sub_ref "D 9"
          required
          yes_no
          context %(
            <p>Answer yes if you received such support during the last five years or at any time if it was in relation to your innovation.</p>

            <p> To receive grant funding or other government support, the organisation must usually undergo a rigorous vetting process, so if you have received any such funding, assessors will find it reassuring. However, many companies self-finance, and the assessors appreciate that as well.</p>
          )
        end

        textarea :innovation_grant_funding_sources, "Provide details of dates, sources, types and, if relevant, amounts of the government support you received in relation to your innovation (at any time)." do
          classes "sub-question word-max-strict"
          sub_ref "D 9.1"
          required
          context %(
            <p>If none of the support was in relation to your innovation, please state so.</p>
          )
          conditional :innovations_grant_funding, :yes
          rows 3
          words_max 250
        end

        textarea :innovation_grant_funding_sources_in_application_period, "Provide details of dates, sources, types and, if relevant, amounts of the government support you received during the last five years." do
          classes "sub-question word-max-strict"
          sub_ref "D 9.2"
          required
          context %(
            <p>If the support was in relation to your innovation, don't repeat it.</p>
          )
          conditional :innovations_grant_funding, :yes
          rows 3
          words_max 250
        end

        options :product_estimated_figures, "Are any of the figures used on this page estimates?" do
          required
          ref "D 10"
          yes_no
          context %(
            <p>
              If you haven't reached or finalised your latest year-end yet, it is acceptable to use estimated figures.
            </p>
          )
          conditional :financial_year_date_changed, :true
        end

        confirm :agree_to_provide_actual_figures, "Agreement to provide actual figures" do
          classes "sub-question"
          sub_ref "D 10.1"
          required
          text " I understand that if this application is shortlisted, I will have to provide actual figures that have been verified by an external accountant before the specified November deadline (the exact date will be provided in the shortlisting email)."
          conditional :product_estimated_figures, :yes
          conditional :financial_year_date_changed, :true
        end

        textarea :product_estimates_use, "Explain your use of estimates and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "D 10.2"
          required
          rows 2
          words_max 200
          conditional :product_estimated_figures, :yes
          conditional :financial_year_date_changed, :true
        end
      end
    end
  end
end
