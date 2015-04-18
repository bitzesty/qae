# -*- coding: utf-8 -*-
class QAE2014Forms
  class << self
    def trade_step3
      @trade_step3 ||= proc do
        trade_commercial_success :trade_commercial_success, "" do
          main_header %(
            How would you describe your organisation's growth and commercial success (i.e. turnover and profit) in international trade?
                    )
          classes "js-entry-period"
          ref "C 1"
          required
          option "3 to 5", "Outstanding growth in the last 3 years"
          option "6 plus", "Continuous growth in the last 6 years"
          placeholder_preselected_condition :queen_award_holder_details,
                                            question_suffix: :year,
                                            question_value: "3 to 5",
                                            placeholder_text: %{
              As you currently hold a Queen's Award for Continuous Achievement in International Trade (6 years), you can only apply for the Outstanding Achievement Award (3 years).
            }

          financial_date_selector({
            "3 to 5" => "3",
            "6 plus" => "6"
          })
          sub_category_question
        end

        innovation_financial_year_date :financial_year_date, "Please enter your financial year end date." do
          ref "C 2"
          required
          context %(
            <p>If you haven't reached/finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application.</p>
                    )
          financial_date_pointer
        end

        options :financial_year_date_changed, "Did your year-end date change during your (<span class='js-entry-period-subtext'>3 or 6</span> year) entry period?" do
          classes "sub-question js-financial-year-change"
          required
          yes_no
        end

        by_years_label :financial_year_changed_dates, "Enter your year-end dates for each financial year." do
          classes "sub-question"
          sub_ref "C 2.1"
          required
          type :date
          label ->(y) { "Financial year #{y}" }
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          conditional :trade_commercial_success, :true
          conditional :financial_year_date_changed, "yes"
        end

        textarea :financial_year_date_changed_explaination, "Please explain why your year-end date changed." do
          classes "sub-question"
          sub_ref "C 2.2"
          required
          rows 5
          words_max 100
          conditional :financial_year_date_changed, "yes"
        end

        by_years :employees, "Enter the number of people employed by your organisation in the UK in each year of your entry." do
          ref "C 3"
          required
          context %(
            <p>You can use the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. Only include those on the payroll.</p>
                    )
          type :number
          label ->(y) { "Financial year #{y}" }
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          conditional :trade_commercial_success, :true
          conditional :financial_year_date_changed, :true

          employees_question
        end

        header :company_financials, "Company Financials" do
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
          )
          conditional :trade_commercial_success, :true
          conditional :financial_year_date_changed, :true
        end

        textarea :trade_excluded_explanation, "In question A12.6 you said you are applying on behalf of a group but are excluding some member(s)'s financial figures. Please explain why." do
          ref "C 4"
          rows 5
          words_max 150
          conditional :trade_commercial_success, :true
          conditional :financial_year_date_changed, :true
          conditional :applying_for, "organisation"
          conditional :parent_group_entry, "yes"
          conditional :pareent_group_excluding, "yes"
        end

        options :do_you_want_to_calculate_overseas_and_so_on, "If your organisation is in the financial (or related) services sector and is cyclical in nature, you can calculate overseas sales and total sales as rolling averages. Do you want to do this?" do
          ref "C 5"
          context %(
            <p>
              Entries for Outstanding Achievement must submit three three-year rolling averages, whilst Continuous Achievement requires six three-year rolling averages. You should calculate these yourself and enter the resulting figures.
            </p>
          )
          conditional :trade_commercial_success, :true
          yes_no
        end

        # TODO: add validation "Must be greater than £100,000"
        by_years :overseas_sales, "Total overseas sales" do
          ref "C 6"
          required
          context %(
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
                    )
          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          first_year_min_value "100000", "Cannot be less than £100,000"
          conditional :trade_commercial_success, :true
          drop_block_conditional
        end

        by_years :total_turnover, "Total turnover (home plus overseas)" do
          classes "sub-question"
          sub_ref "C 6.3"
          type :money
          required
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %(
            <p>Exclude VAT, overseas taxes and, where applicable, excise duties.</p>
                    )
          conditional :trade_commercial_success, :true
          drop_conditional :drops_in_turnover
        end

        by_years :net_profit, "Net profit after tax but before dividends" do
          classes "sub-question"
          sub_ref "C 6.4"
          required
          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %(
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
                    )
          conditional :trade_commercial_success, :true
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover, "Explain any drops in total turnover or net profit, and any losses made." do
          classes "sub-question js-conditional-drop-question"
          sub_ref "C 6.5"
          rows 5
          words_max 500
          conditional :trade_commercial_success, :true
          drop_condition_parent
        end

        options :resale_overseas, "Do you purchase your products/services (or any of their components) from overseas for resale overseas?" do
          classes "sub-question"
          sub_ref "C 6.7"
          required
          yes_no
          context %(
            <p>Excluding raw materials and value added.</p>
                    )
          conditional :trade_commercial_success, :true
        end

        by_years :total_imported_cost, "Total cost of these imports" do
          classes "sub-question"
          sub_ref "C 6.8"
          required
          type :money
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          context %(
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.
                    )
          conditional :trade_commercial_success, :true
          conditional :resale_overseas, "yes"
          drop_conditional :drops_in_turnover
        end

        options :company_estimated_figures, "Are any of the figures used on this page estimates?" do
          ref "C 7"
          yes_no
          conditional :trade_commercial_success, :true
        end

        textarea :company_estimates_use, "Explain your use of estimates, and how much of these are actual receipts or firm orders." do
          classes "sub-question"
          sub_ref "C 7.1"
          rows 5
          words_max 400
          conditional :trade_commercial_success, :true
          conditional :company_estimated_figures, "yes"
        end

        options :manufacture_overseas, "Do you manufacture overseas?" do
          ref "C 8"
          required
          yes_no
        end

        by_years :overseas_yearly_percentage, "Indicate the yearly percentage of your goods produced overseas." do
          classes "sub-question"
          sub_ref "C 8.1"
          required
          type :percent
          by_year_condition :trade_commercial_success, "3 to 5", 3
          by_year_condition :trade_commercial_success, "6 plus", 6
          conditional :trade_commercial_success, :true
          conditional :manufacture_overseas, "yes"
        end

        textarea :manufacture_model_benefits, "Describe the benefits of this business model to the UK." do
          classes "sub-question"
          sub_ref "C 8.2"
          rows 5
          words_max 400
          conditional :manufacture_overseas, "yes"
        end

        options :operate_overseas, "Do you run your overseas operations as a franchise?" do
          ref "C 9"
          required
          yes_no
        end

        textarea :operate_model_benefits, "Describe the benefits of this business model to the UK." do
          classes "sub-question"
          sub_ref "C 9.1"
          required
          rows 5
          words_max 500
          conditional :operate_overseas, "yes"
        end

        options :received_grant, "Did you receive any grant funding to support this product/service?" do
          ref "C 10"
          required
          yes_no
        end

        textarea :funding_details, "Please give details of date(s), source(s) and level(s) of funding." do
          classes "sub-question"
          sub_ref "C 10.1"
          required
          rows 5
          words_max 300
          conditional :received_grant, "yes"
        end
      end
    end
  end
end
