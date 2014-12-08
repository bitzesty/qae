class QAE2014Forms
  class << self
    def trade_step2
      @trade_step2 ||= Proc.new {
        # TODO Hide this when A5 "List the Queen's Award(s) you currently hold" has a value "International Trade (6 years)"
        # Act as if this is preslected with "6 plus" for dependent questions below
        options :trade_commercial_success, "For how long has your organisation seen growth and commercial success in its international trade?" do
          ref 'B 1'
          required
          context %Q{
            <p>Your answer here will determine whether you are assessed for outstanding (over  three years) or continuous (over six years) achievement in international trade.</p>
          }
          option '3 to 5', '3-5 years'
          option '6 plus', '6 years or more'
        end

        # TODO Show this when A5 "List the Queen's Award(s) you currently hold" has a value "International Trade (6 years)"
        # Act as if the B1 above is preslected with "6 plus" for dependent questions below
        #header :trade_commercial_success_preselected, "Because you are the current holder of a Queen's Award for Continuous Achievement in International Trade (6 years), you may only apply for the Outstanding Achievement Award (3 years) this year." do
        #  ref 'B 1'
        #end

        trade_financial_year_dates :financial_year_dates, 'Please select your financial year end dates:' do
          ref 'B 2'
          required
          context %Q{
            <p>If you haven't reached/finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application.</p>
          }
          conditional :trade_commercial_success, :true
        end

        number :employees, 'State the number of people employed by the company for each year of your entry.' do
          ref 'B 3'
          required
          context %Q{
            <p>State the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. Only include those on the payroll.</p>
          }
          style "small"
          min 2
          conditional :trade_commercial_success, :true
        end

        header :company_financials, 'Company Financials' do
          ref 'B 4'
          conditional :trade_commercial_success, :true
        end

        trade_by_years :overseas_sales, 'Direct overseas sales' do
          classes "sub-question"
          required
          context %Q{
            <p>guidance text for this question is carnage</p>
          }
          conditional :trade_commercial_success, :true
          drop_conditional :drops_in_turnover
        end

        trade_by_years :total_turnover, 'Total turnover (home plus overseas)' do
          classes "sub-question"
          required
          conditional :trade_commercial_success, :true
          drop_conditional :drops_in_turnover
        end

        trade_by_years :net_profit, 'Net profit after tax but before dividends' do 
          classes "sub-question"
          required
          conditional :trade_commercial_success, :true
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover, "Explain any drops in turnover or net profit, and any losses made." do
          classes "sub-question js-conditional-drop-question"
          rows 5
          words_max 500
          conditional :trade_commercial_success, :true
        end

        options :company_estimated_figures, 'Are any of these figures estimated?' do
          classes "sub-question"
          yes_no
          conditional :trade_commercial_success, :true
        end

        textarea :company_estimates_use, 'Explain the use of estimates, and how much of these are actual receipts or firm orders.' do
          classes "sub-question"
          rows 5
          words_max 200
          conditional :trade_commercial_success, :true
          conditional :company_estimated_figures, :yes
        end

        options :resale_overseas, 'Do you purchase your products/services (or any of their components) from overseas for resale overseas?' do
          classes "sub-question"
          yes_no
          context %Q{
            <p>Excluding raw materials and value added.</p>
          }
          conditional :trade_commercial_success, :true
        end

        trade_by_years :total_imported_cost, 'Total cost of the imported products/services/components' do 
          classes "sub-question"
          required
          conditional :trade_commercial_success, :true
          conditional :resale_overseas, :true
          drop_conditional :drops_in_turnover
        end

        options :manufacture_overseas, 'Do you manufacture overseas?' do
          ref 'B 5'
          required
          yes_no
        end

        trade_by_years_percentage :overseas_yearly_percentage, 'Indicate the yearly percentage of your goods produced overseas.' do 
          classes "sub-question"
          required
          conditional :trade_commercial_success, :true
          conditional :manufacture_overseas, :true
        end

        textarea :manufacture_model_benefits, 'Describe the benefits of this business model to the UK.' do
          classes "sub-question"
          rows 5
          words_max 400
          conditional :manufacture_overseas, :true
        end

        options :operate_overseas, 'Does you franchise your operations overseas?' do
          ref 'B 6'
          required
          yes_no
        end

        textarea :operate_model_benefits, 'Describe the benefits of this business model to the UK.' do
          classes "sub-question"
          required
          rows 5
          words_max 500
          conditional :operate_overseas, :true
        end

        options :received_grant, 'Have you received any grant funding to support this product/service?' do
          ref 'B 7'
          required
          yes_no
        end

        textarea :funding_details, 'Please give details of date(s), source(s) and level(s) of funding.' do
          classes "sub-question"
          required
          rows 5
          words_max 300
          conditional :received_grant, :true
        end
      }
    end
  end
end
