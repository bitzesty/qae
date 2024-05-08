# -*- coding: utf-8 -*-
class AwardYears::V2019::QaeForms
  class << self
    def development_step3
      @development_step3 ||= proc do
        header :commercial_success_info_block, "" do
          context %(
            <p>
              All applicants for any Queen’s Award must demonstrate a certain level of financial performance. This section enables you to demonstrate the impact that your sustainable development had on your organisation's financial performance.
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
              You can provide estimated figures for now but, should you be shortlisted, you will have to provide the actual figures that have been verified by an independent accountant by November.
            </p>
          )
        end

        options :development_performance_years, "How would you describe the impact of your sustainable development on your organisation's financial performance?" do
          classes "js-entry-period"
          ref "C 1"
          required
          option "2 to 4", "Outstanding Sustainable Development: sustainable development has improved commercial performance over two years"
          option "5 plus", "Continuous Sustainable Development: sustainable development has improved commercial performance over five years"
          financial_date_selector({
            "2 to 4" => "2",
            "5 plus" => "5",
          })
          default_option "5 plus"
          sub_category_question
          context %(
            <p>
              Your answer here will determine whether you are assessed for outstanding sustainable development (over two years) or continuous sustainable development (over five years).
            </p>
          )
        end

        innovation_financial_year_date :financial_year_date, "Please enter your financial year end date." do
          ref "C 2"
          required
          context %(
            <p>If you haven't reached or finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application. If shortlisted, these figures will need to be verified by an independent accountant within a specified deadline.</p>
          )
          financial_date_pointer
        end

        options :financial_year_date_changed, "Did your year-end date change during your <span class='js-entry-period-subtext'>2 or 5</span> year entry period?" do
          classes "sub-question js-financial-year-change"
          sub_ref "C 2.1"
          required
          yes_no
          context %(
            <p>
              We ask this to obtain all of the commercial figures we need to assess your application. You should ensure that any data supporting your application covers <span class='js-entry-period-subtext'>2 or 5</span> full 12-month periods.
            </p>
          )
          default_option "no"
        end

        by_years_label :financial_year_changed_dates, "Please enter your year-end dates for each financial year." do
          classes "sub-question"
          sub_ref "C 2.2"
          required
          type :date
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.development.years_question_additional_context")

          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          conditional :development_performance_years, :true
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

        by_years :employees, "Enter the number of people employed by your organisation in the UK in each year of your entry." do
          classes "question-employee-min"
          ref "C 3"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. </p>
          )
          type :number
          label ->(y) { "Financial year #{y}" }

          additional_pdf_context I18n.t("pdf_texts.development.years_question_additional_context")

          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true

          employees_question
        end
        # TODO: Min 2 - if less than 2 block - present 'you are not eligible' message

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

          conditional :development_performance_years, :true
        end

        by_years :total_turnover, "Total turnover" do
          ref "C 4.1"
          required
          classes "sub-question"

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5

          additional_pdf_context I18n.t("pdf_texts.development.years_question_additional_context")
          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        by_years :exports, "Of which exports" do
          classes "sub-question"
          sub_ref "C 4.2"
          required
          context %(<p>Please enter '0' if you had none.</p>)

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          additional_pdf_context I18n.t("pdf_texts.development.years_question_additional_context")

          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        # UK sales = turnover - exports
        turnover_exports_calculation :uk_sales, "Of which UK sales" do
          classes "sub-question"
          sub_ref "C 4.3"
          label ->(y) { "Financial year #{y}" }
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          additional_pdf_context I18n.t("pdf_texts.development.years_question_additional_context")

          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          turnover :total_turnover
          exports :exports

          context %(
            <p>
              This number is automatically calculated using your total turnover and export figures.
            </p>
          )
        end

        by_years :net_profit, "Net profit after tax but before dividends (UK and overseas)" do
          classes "sub-question"
          sub_ref "C 4.4"
          required

          type :money
          label ->(y) { "Financial year #{y}" }
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          context %(
            <p>
              Use a minus symbol to record any losses.
            </p>
          )
          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          additional_pdf_context I18n.t("pdf_texts.development.years_question_additional_context")
          drop_conditional :drops_in_turnover
        end

        by_years :total_net_assets, "Total net assets" do
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
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          additional_pdf_context I18n.t("pdf_texts.development.years_question_additional_context")

          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover, "Explain any drops in turnover, export sales, total net assets and net profits, as well as any losses made." do
          classes "sub-question js-conditional-drop-question"
          sub_ref "C 4.6"
          rows 5
          words_max 200
          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
          drop_condition_parent
        end

        options :entry_relates_to, "How does the sustainable development product, service or management approach that forms the basis of this application fit within the overall business?" do
          ref "C 5"
          required
          option :entire_business, "It's integral to the whole business"
          option :single_product_or_service, "It affects specific product, service or management approach"
          context %(
            <p>
              It is important that we know whether or not your sustainable development is the key thing your business does, or forms part of a wider approach. This is so we can understand the commercial value of your sustainable development in the context of your overall commercial performance.
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

        by_years :units_sold, "Number of units/contracts sold (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.1"
          type :number
          label "..."
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          additional_pdf_context I18n.t("pdf_texts.development.years_question_additional_context")
          drop_conditional :drops_in_sales
        end

        by_years :sales, "Sales (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.2"
          type :money
          label "..."
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          drop_conditional :drops_in_sales
        end

        by_years :sales_exports, "Of which exports (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.3"
          context %(<p>Please enter '0' if you had none.</p>)
          type :money
          label "..."
          additional_pdf_context I18n.t("pdf_texts.development.years_question_additional_context")
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          drop_conditional :drops_in_sales
        end

        by_years :sales_royalties, "Of which royalties or licences (if applicable)" do
          classes "sub-question"
          sub_ref "C 6.4"
          context %(<p>Please enter '0' if you had none.</p>)
          type :money
          label "..."
          additional_pdf_context I18n.t("pdf_texts.development.years_question_additional_context")
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
          drop_conditional :drops_in_sales
        end

        textarea :drops_in_sales, "Explain any drop in sales or number of units sold (if applicable)" do
          classes "sub-question js-conditional-drop-question"
          sub_ref "C 6.5"
          rows 5
          words_max 250
          drop_condition_parent
        end

        by_years :avg_unit_cost_self, "Direct cost, to you, of a single unit/contract (if applicable)" do
          sub_ref "C 6.6"
          classes "sub-question"
          type :money
          label "..."

          additional_pdf_context I18n.t("pdf_texts.development.years_question_additional_context")
          by_year_condition :development_performance_years, "2 to 4", 2
          by_year_condition :development_performance_years, "5 plus", 5
        end

        textarea :costs_change_desc, "Explain your direct unit/ contract costs, highlighting any changes over the above periods (if applicable)." do
          classes "sub-question"
          sub_ref "C 6.7"
          rows 5
          words_max 250
        end

        options :product_estimated_figures, "Are any of the figures used on this page estimates?" do
          ref "C 7"
          required
          yes_no
          conditional :development_performance_years, :true
          conditional :financial_year_date_changed, :true
        end

        textarea :product_estimates_use, "Explain the use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "C 7.1"
          required
          rows 5
          words_max 250
          conditional :product_estimated_figures, :yes
          conditional :development_performance_years, :true
        end

        textarea :development_performance, "What cost-savings have you or your customers' businesses made as a result of the introduction of the product, service or management approach?" do
          ref "C 8"
          required
          context %(
            <p>
              Please describe the cost savings and/or other benefits in addition to the sustainability impact you have already demonstrated in section B of this form. Please provide figures if known.
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :investments_details, "Please enter details of all investments and reinvestments (capital and operating costs) in your product/service/management approach." do
          ref "C 9"
          required
          context %(
            <p>Include all investments and reinvestments made both during and before your entry period. Also, include the year(s) in which they were made.</p>
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
