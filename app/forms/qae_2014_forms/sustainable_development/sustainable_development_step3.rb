class QAE2014Forms
  class << self
    def development_step3
      @development_step3 ||= Proc.new {
        options :development_performance_years, "For how long have your achievements in sustainable development  had substantial impact on (ie. measurably improved) your organisation's performance?" do
          ref 'C 1'
          required
          context %Q{
            <p>Your answer here will determine whether you are assessed for outstanding (over two years) or continuous (over five years) achievement in sustainable development.</p>
          }
          option '2 to 4', '2-4 years'
          option '5 plus', '5 years or more'
        end

        development_financial_year_dates :financial_year_dates, 'State your financial year end date' do
          ref 'C 2'
          required
          context %Q{
            <p>If you haven't reached/finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application.</p>
          }
          conditional :development_performance_years, :true
        end

        development_by_years_number :employees, 'State the number of people employed by the company for each year of your entry.' do
          ref 'C 3'
          required
          context %Q{
            <p>State the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. Only include those on the payroll.</p>
          }
          conditional :development_performance_years, :true
        end

        options :entry_relates_to, 'My entry relates to' do
          ref 'C 4'
          required
          option :entire_business, 'The entire business'
          option :single_product_or_service, 'A single product or service'
        end

        header :company_financials, 'Company Financials' do
          context %Q{
            <p>These figures should be for your entire organisation.</p>
          }
          conditional :development_performance_years, :true
        end

        textarea :innovation_excluded_explanation, 'Parent companies making group entries should include figures for all UK subsidiaries. If any part of the group is excluded, please provide an explanation here.' do
          ref 'C 5'
          rows 5
          words_max 150
          conditional :innovation_performance_years, :true
        end

        development_by_years :total_turnover, 'Total turnover' do
          ref 'C 6'
          required
          conditional :development_performance_years, :true
          drop_conditional :drops_in_turnover
        end

        development_by_years :exports, 'of which exports' do 
          classes "sub-question"
          required
          context %Q{<p>Please enter '0' if you had none.</p>}
          conditional :development_performance_years, :true
          drop_conditional :drops_in_turnover
        end

        development_by_years :net_profit, 'Net profit after tax but before dividends' do 
          classes "sub-question"
          required
          conditional :development_performance_years, :true
          drop_conditional :drops_in_turnover
        end

        development_by_years :total_net_assets, 'Total net assets' do 
          classes "sub-question"
          required
          context %Q{<p>As per your balance sheet. Total assets (fixed and current), less liabilities (current and long-term).}
          conditional :development_performance_years, :true
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover, "Explain any drops in turnover, export sales, total net assets and net profits, as well as any losses made." do
          classes "sub-question js-conditional-drop-question"
          rows 5
          words_max 200
          conditional :development_performance_years, :true
        end

        options :company_estimated_figures, 'Are any of these figures estimated?' do
          classes "sub-question"
          yes_no
          conditional :development_performance_years, :true
          conditional :entry_relates_to, :entire_business
        end

        textarea :company_estimates_use, 'Explain the use of estimates, and how much of these are actual receipts or firm orders.' do
          classes "sub-question"
          rows 5
          words_max 200
          conditional :development_performance_years, :true
          conditional :company_estimated_figures, :yes
        end

        header :product_financials, 'Product/Service Financials' do
          ref 'C 7'
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end
 
        development_by_years_number :units_sold, 'Number of units/contracts sold' do
          classes "sub-question"
          required
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
          drop_conditional :drops_in_sales
        end

        development_by_years :sales, 'Sales' do 
          classes "sub-question"
          required
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
          drop_conditional :drops_in_sales
        end

        development_by_years :sales_exports, 'of which exports' do
          classes "sub-question"
          context %Q{<p>Please enter '0' if you had none.</p>}
          required
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
          drop_conditional :drops_in_sales
        end

        development_by_years :sales_royalties, 'of which royalties or licenses' do
          classes "sub-question"
          context %Q{<p>Please enter '0' if you had none.</p>}
          required
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
          drop_conditional :drops_in_sales
        end

        textarea :drops_in_sales, "Explain any drop in sales" do
          classes "sub-question js-conditional-drop-question"
          required
          rows 5
          words_max 300
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        options :product_estimated_figures, 'Are any of these figures estimated?' do
          classes "sub-question"
          yes_no
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        textarea :product_estimates_use, 'Explain the use of estimates, and how much of these are actual receipts or firm orders.' do
          classes "sub-question"
          rows 5
          words_max 200
          conditional :product_estimated_figures, :yes
          conditional :development_performance_years, :true
        end

        textarea :financial_comments, 'Additional comments' do
          classes "sub-question"
          rows 5
          words_max 100
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        development_by_years :avg_unit_price, 'Average unit selling price/contract value' do 
          ref 'C 8'
          required
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        textarea :avg_unit_price_desc, 'Explain your unit selling prices/contract values, highlighting any changes over the above periods.' do
          classes "sub-question"
          required
          rows 5
          words_max 200
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        development_by_years :avg_unit_cost_self, 'Cost, to you, of a single unit/contract' do 
          ref 'C 9'
          required
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        textarea :costs_change_desc, 'Explain your unit/ contract costs, highlighting any changes over the above periods.' do
          classes "sub-question"
          required
          rows 5
          words_max 200
          conditional :entry_relates_to, :single_product_or_service
          conditional :development_performance_years, :true
        end

        textarea :development_performance, "Explain the cost savings you or your customers' businesses made as a result of the introduction of the product/service/management approach." do
          ref 'C 10'
          required
          context %Q{
            <p>Use figures if known.</p>
          }
          rows 5
          words_max 300
        end 

        textarea :investments_details, "Please enter details of all investments made in your product/service/management approach on a yearly basis both during and prior to your entry period." do
          ref 'C 11'
          required
          rows 5
          words_max 500
        end

        textarea :roi_details, 'How long did it take the investment indicated above to be repaid out of profits? When and how was this repayment achieved?' do
          ref 'C 12'
          classes "sub-question"
          required
          context %Q{
            <p>When calculating expenditure paid for out of profits, please include capital costs where appropriate.</p>
          }
          rows 5
          words_max 500
        end
      }
    end
  end
end
