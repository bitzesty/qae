class QAE2014Forms
  class << self
    def innovation_step3
      @innovation_step3 ||= Proc.new {
        options :innovation_performance_years, "How would you describe the impact of your innovation on your organisation's financial performance (i.e. turnover and profit)?" do
          classes "js-entry-period"
          ref 'C 1'
          required
          context %Q{
            <p>Your answer here will determine whether you are assessed for outstanding innovation (over two years) or continuous innovation (over five years).</p>
          }
          option '2 to 4', 'Outstanding performance improvements over the last 2 years'
          option '5 plus', 'Steady performance improvements over the last 5 years'
        end

        innovation_financial_year_date :financial_year_date, 'Please enter your financial year end date.' do
          ref 'C 2'
          required
          context %Q{
            <p>If you haven't reached/finalised your latest year-end yet, please enter it anyway and use financial estimates to complete your application.</p>
          }
        end

        options :financial_year_date_changed, 'Did your year-end date change during your 2 or 5 year entry period?' do
          classes "sub-question js-entry-period-substitute-text"
          required
          yes_no
        end

        innovation_financial_year_dates :financial_year_changed_dates, 'Enter your year-end dates for each financial year.' do
          classes "sub-question"
          required
          conditional :financial_year_date_changed, :yes
        end

        textarea :financial_year_date_changed_explaination, 'Please explain why your year-end date changed.' do
          classes "sub-question"
          rows 5
          words_max 100
          conditional :financial_year_date_changed, :yes
        end

        innovation_by_years_number :employees, 'Enter the number of people employed by your organisation in each year of your entry.' do
          ref 'C 3'
          required
          context %Q{
            <p>You can use the number of full-time employees at the year-end, or the average for the 12 month period. Part-time employees should be expressed in full-time equivalents. Only include those on the payroll.</p>
          }
          conditional :innovation_performance_years, :true
        end

        options :innovation_part_of, 'The innovation is an integral part of' do
          ref 'C 4'
          required
          option :entire_business, 'The entire business'
          option :single_product_or_service, 'A single product or service'
        end

        header :company_financials, 'Company Financials' do
          context %Q{
            <p>These figures should be for your entire organisation. If you haven't reached your latest year-end, please use estimates to complete this section.</p>
          }
          conditional :innovation_performance_years, :true
        end

        textarea :innovation_excluded_explanation, 'Parent companies making group entries should include figures for all UK members of the group. If any member is excluded, please explain why.' do
          ref 'C 5'
          rows 5
          words_max 150
          conditional :innovation_performance_years, :true
        end

        innovation_by_years :total_turnover, 'Total turnover' do
          ref 'C 6'
          required
          context %Q{
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
          }
          conditional :innovation_performance_years, :true
          drop_conditional :drops_in_turnover
        end

        innovation_by_years :exports, 'of which exports' do 
          classes "sub-question"
          required
          context %Q{<p>Please enter '0' if you had none.</p>}
          conditional :innovation_performance_years, :true
          drop_conditional :drops_in_turnover
        end

        innovation_by_years :net_profit, 'Net profit after tax but before dividends' do 
          classes "sub-question"
          required
          conditional :innovation_performance_years, :true
          drop_conditional :drops_in_turnover
        end

        innovation_by_years :total_net_assets, 'Total net assets' do 
          classes "sub-question"
          required
          context %Q{<p>As per your balance sheet. Total assets (fixed and current), less liabilities (current and long-term).}
          conditional :innovation_performance_years, :true
          drop_conditional :drops_in_turnover
        end

        textarea :drops_in_turnover, "Explain any drops in turnover, export sales, total net assets and net profits, as well as any losses made." do
          classes "sub-question js-conditional-drop-question"
          rows 5
          words_max 200
          conditional :innovation_performance_years, :true
        end

        options :company_estimated_figures, 'Are any of these figures estimated?' do
          classes "sub-question"
          yes_no
          conditional :innovation_performance_years, :true
          conditional :innovation_part_of, :entire_business
        end

        textarea :company_estimates_use, 'Explain your use of estimates, and how much of these are actual receipts or firm orders.' do
          classes "sub-question"
          rows 5
          words_max 200
          conditional :innovation_performance_years, :true
          conditional :company_estimated_figures, :yes
        end

        header :product_financials, 'Product/Service Financials' do
          ref 'C 7'
          context %Q{
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
          }
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
        end
 
        innovation_by_years_number :units_sold, 'Number of units/contracts sold' do
          classes "sub-question"
          required
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          drop_conditional :drops_in_sales
        end

        innovation_by_years :sales, 'Sales' do 
          classes "sub-question"
          required
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          drop_conditional :drops_in_sales
        end

        innovation_by_years :sales_exports, 'of which exports' do
          classes "sub-question"
          context %Q{<p>Please enter '0' if you had none.</p>}
          required
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          drop_conditional :drops_in_sales
        end

        innovation_by_years :sales_royalties, 'of which royalties or licenses' do
          classes "sub-question"
          context %Q{<p>Please enter '0' if you had none.</p>}
          required
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
          drop_conditional :drops_in_sales
        end

        textarea :drops_in_sales, "Explain any drop in sales" do
          classes "sub-question js-conditional-drop-question"
          required
          rows 5
          words_max 300
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
        end

        options :product_estimated_figures, 'Are any of these figures estimated?' do
          classes "sub-question"
          yes_no
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
        end

        textarea :product_estimates_use, 'Explain your use of estimates, and how much of these are actual receipts or firm orders.' do
          classes "sub-question"
          rows 5
          words_max 200
          conditional :product_estimated_figures, :yes
          conditional :innovation_performance_years, :true
        end

        textarea :financial_comments, 'Additional comments (optional)' do
          classes "sub-question"
          rows 5
          context %Q{
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
          }
          words_max 100
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
        end

        innovation_by_years :avg_unit_price, 'Average unit selling price/contract value' do 
          ref 'C 8'
          required
          context %Q{
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
          }
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
        end

        textarea :avg_unit_price_desc, 'Explain any changes in your unit selling prices/contract values over this period.' do
          classes "sub-question"
          required
          rows 5
          words_max 300
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
        end

        innovation_by_years :avg_unit_cost_self, 'Cost, to you, of a single unit/contract' do 
          ref 'C 9'
          required
          context %Q{
            <p>If you haven't reached your latest year-end, please use estimates to complete this question.</p>
          }
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
        end

        textarea :costs_change_desc, 'Explain your unit/ contract costs, highlighting any changes over the above periods.' do
          classes "sub-question"
          required
          rows 5
          words_max 300
          conditional :innovation_part_of, :single_product_or_service
          conditional :innovation_performance_years, :true
        end

        textarea :innovation_performance, 'Describe how, when, and to what extent the innovation improved the commercial performance of your business. Also explain any cost savings you made as a result of the innovation.' do
          ref 'C 10'
          required
          rows 5
          words_max 300
        end 

        textarea :investments_details, 'Please enter details of all your investments in the innovation. *Include all investments made both during and prior to your entry period.* Also include the year(s) in which they were made.' do
          ref 'C 11'
          required
          rows 5
          words_max 300
        end

        textarea :roi_details, 'How long did it take you to recover the investment indicated above? When and how did you achieve this?' do
          classes "sub-question"
          required
          rows 5
          words_max 300
        end

      }
    end
  end
end
