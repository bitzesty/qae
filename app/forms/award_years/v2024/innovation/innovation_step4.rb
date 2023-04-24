# -*- coding: utf-8 -*-
class AwardYears::V2024::QAEForms
  class << self
    def innovation_step4
      @innovation_step4 ||= proc do
        about_section :commercial_success_info_block, "" do
          section "innovation_commercial_performance"
        end

        innovation_financial_year_date :financial_year_date, "Enter your financial year-end date." do
          ref "D 1"
          required
          financial_date_pointer
        end

        trade_most_recent_financial_year_options :most_recent_financial_year, "Which year would you like to be your most recent financial year that you will submit figures for?" do
          ref "D 1.1"
          required
          option (AwardYear.current.year - 2).to_s, (AwardYear.current.year - 2).to_s
          option (AwardYear.current.year - 1).to_s, (AwardYear.current.year - 1).to_s
          default_option (AwardYear.current.year - 1).to_s

          classes "js-most-recent-financial-year"
          context %(
            <p>
              Answer this question if your dates in question D1 range between #{Settings.current_award_year_switch_date.decorate.formatted_trigger_date} to #{Settings.current.deadlines.submission_end.first.decorate.formatted_trigger_date}.
            </p>
          )
        end

        options :financial_year_date_changed, "Did your year-end date change during your <span class='js-entry-period-subtext'>five</span> most recent financial years that you will be providing figures for?" do
          classes "sub-question js-financial-year-change"
          sub_ref "D 2"
          required
          yes_no
          default_option "no"
        end

        by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question"
          sub_ref "D 2.1"
          required
          type :date
          label ->(y) { "Financial year #{y}" }

          context %(
            <p>
              Answer this question if you selected 'Yes' in question D 2.
            </p>
            <p>
              For the purpose of this application, your most recent financial year-end is your last financial year ending before the #{Settings.current_submission_deadline.decorate.formatted_trigger_date('with_year')} - the application submission deadline.
            </p>
          )

          additional_pdf_context I18n.t("pdf_texts.trade.years_question_additional_context")

          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}
          conditional :financial_year_date_changed, "yes"
        end

        textarea :adjustments_explanation, "Explain adjustments to figures." do
          classes "sub-question"
          sub_ref "D 2.2"
          required
          rows 2
          words_max 200
          context %(
            <p>
              Answer this question if you selected 'Yes' in question D 2.
            </p>
            <p>
              If your financial year-end has changed, you will need to agree with your accountants on how to allocate your figures so that they equal 12-month periods. This allows for a comparison between years.
            </p>
            <p>
              Please explain what approach you will take to adjust the figures.
            </p>
          )
          conditional :financial_year_date_changed, "yes"
        end

        textarea :financial_year_date_changed_explaination, "Please explain why your year-end date changed." do
          classes "sub-question"
          sub_ref "D 2.3"
          required
          rows 1
          words_max 100
          context %(
            <p>
              Answer this question if you selected 'Yes' in question D 2.
            </p>
          )
          conditional :financial_year_date_changed, :yes
        end

        by_years :employees, "Enter the number of people employed by your organisation in the UK." do
          classes "question-employee-min"
          ref "D 3"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end or the average for the 12-month period. Part-time employees should be expressed in full-time equivalents (FTEs).</p>
          )
          type :number
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}
          conditional :financial_year_date_changed, :true
          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")

          employees_question
        end

        about_section :company_financials, "Company Financials" do
          ref "D 4"
          section "company_financials"
          conditional :financial_year_date_changed, :true
        end

        by_years :total_turnover, "Total turnover." do
          ref "D 4.1"
          required
          classes "sub-question"

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          conditional :financial_year_date_changed, :true
        end

        by_years :exports, "Of which exports." do
          classes "sub-question"
          sub_ref "D 4.2"
          required
          context %(<p>Enter '0' if you had none.</p>)

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          conditional :financial_year_date_changed, :true
        end

        # UK sales = turnover - exports
        turnover_exports_calculation :uk_sales, "Of which UK sales." do
          classes "sub-question"
          sub_ref "D 4.3"
          context %(<p>This number is automatically calculated using your total turnover and export figures.</p>)
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          conditional :financial_year_date_changed, :true
          turnover :total_turnover
          exports :exports
        end

        by_years :net_profit, "Net profit after tax but before dividends (the UK and overseas)." do
          classes "sub-question"
          sub_ref "D 4.4"
          required

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}
          context %(
            <p>
              Use a minus symbol to record any losses.
            </p>
          )

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")

          conditional :financial_year_date_changed, :true
        end

        by_years :total_net_assets, "Total net assets." do
          classes "sub-question total-net-assets"
          sub_ref "D 4.5"
          required
          context %(
            <p>
              As per your balance sheet. Total assets (fixed and current) minus liabilities (current and long-term).
            </p>
          )

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")

          type :money
          label ->(y) { "As at the end of year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}

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
          classes "sub-question"
          sub_ref "D 6.1"
          type :number
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}
        end

        by_years :sales, "Sales of your innovative product/service (if applicable)." do
          classes "sub-question"
          sub_ref "D 6.2"
          type :money
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}
        end

        by_years :sales_exports, "Of which exports (if applicable)." do
          classes "sub-question"
          sub_ref "D 6.3"
          context %(<p>Enter '0' if you had none.</p>)
          type :money
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}
        end

        by_years :sales_royalties, "Of which royalties or licences (if applicable)." do
          classes "sub-question"
          sub_ref "D 6.4"
          context %(<p>Enter '0' if you had none.</p>)
          type :money
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}
        end

        textarea :drops_in_sales, "Explain any drop in sales or the number of units sold (if applicable)." do
          classes "sub-question"
          sub_ref "D 6.5"
          rows 2
          words_max 200
        end

        by_years :avg_unit_price, "Average unit selling price or contract value (if applicable)." do
          classes "sub-question"
          sub_ref "D 6.6"
          context %(
            <p>
              If your innovation is a product, you must provide the unit price.
            </p>
          )

          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}
        end

        textarea :avg_unit_price_desc, "Explain your unit selling prices or contract values, highlighting any changes over the above periods (if applicable)." do
          classes "sub-question"
          sub_ref "D 6.7"
          rows 2
          words_max 200
        end

        by_years :avg_unit_cost_self, "Direct cost, to you, of a single unit or contract (if applicable)." do
          classes "sub-question"
          sub_ref "D 6.8"
          context %(
            <p>If you haven't reached your latest year-end, use estimates to complete this question.</p>
          )
          additional_pdf_context I18n.t("pdf_texts.innovation.years_question_additional_context")
          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(2, 3)) }, 2, data: {value: AwardYear.start_trading_between(2, 3, minmax: true, format: true), type: :range, identifier: "2 to 3"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(3, 4)) }, 3, data: {value: AwardYear.start_trading_between(3, 4, minmax: true, format: true), type: :range, identifier: "3 to 4"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(4, 5)) }, 4, data: {value: AwardYear.start_trading_between(4, 5, minmax: true, format: true), type: :range, identifier: "4 to 5"}
          by_year_condition :started_trading, ->(v) { Utils::Date.within_range?(v, AwardYear.start_trading_between(5, 99)) }, 5, data: {value: AwardYear.start_trading_between(5, 99, minmax: true, format: true), type: :range, identifier: "5 plus"}
        end

        textarea :costs_change_desc, "Explain your direct unit or contract costs, highlighting any changes over the above periods (if applicable)." do
          classes "sub-question"
          sub_ref "D 6.9"
          rows 2
          words_max 200
        end

        textarea :innovation_performance, "Describe how, when, and to what extent the innovation has improved the commercial performance of your business." do
          ref "D 7"
          required
          context %(
            <p>
              This may include new sales, cost savings, and their overall effect on turnover and profitability, new investment secured, new orders secured.
            </p>
            <p>
              A couple of examples that may help you answer this question:
              <ul>
                <li>Our innovation is the only product sold and generates 100% of revenue. Our business has been built upon this innovation…</li>
                <li>Our customer management platform has increased customer satisfaction ratings by X%, and our customer retention level has risen by Y% since its introduction. This has enabled us to grow our customer base by Z%...</li>
              </ul>
            </p>
            <p>
              If further improvements are still anticipated, clearly demonstrate how and when in the future they will be delivered.
            </p>
          )
          pdf_context %(
            This may include new sales, cost savings, and their overall effect on turnover and profitability, new investment secured, new orders secured.

            A couple of examples that may help you answer this question:

            \u2022 Our innovation is the only product sold and generates 100% of revenue. Our business has been built upon this innovation…
            \u2022 Our customer management platform has increased customer satisfaction ratings by X%, and our customer retention level has risen by Y% since its introduction. This has enabled us to grow our customer base by Z%...

            If further improvements are still anticipated, clearly demonstrate how and when in the future they will be delivered.
          )
          rows 3
          words_max 250
        end

        textarea :covid_impact_details, "Explain how your business has been responding to the economic uncertainty experienced nationally and globally in recent years." do
          ref "D 8"
          required
          context %(
            <ul>
              <li>How have you adapted to or mitigated the impacts of recent national and global market conditions?</li>
              <li>How are you planning to respond in the year ahead? This could include opportunities you have identified.</li>
              <li>Provide any contextual information or challenges you would like the assessors to consider.</li>
            </ul>
          )
          pdf_context %(
            \u2022 How have you adapted to or mitigated the impacts of recent national and global market conditions?
            \u2022 How are you planning to respond in the year ahead? This could include opportunities you have identified.
            \u2022 Provide any contextual information or challenges you would like the assessors to consider.
          )
          rows 4
          words_max 350
        end

        options :product_estimated_figures, "Are any of the figures used on this page estimates?" do
          ref "D 9"
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
          sub_ref "D 9.1"
          required
          text " I understand that if this application is shortlisted, I will have to provide actual figures that have been verified by an external accountant before the specified November deadline (the exact date will be provided in the shortlisting email)."
          conditional :product_estimated_figures, :yes
          conditional :financial_year_date_changed, :true
        end

        textarea :product_estimates_use, "Explain your use of estimates and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "D 9.2"
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
