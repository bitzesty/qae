class QAE2014Forms
  class << self
    def innovation_step2
      @innovation_step2 ||= Proc.new {
        options :innovation_performance_years, %Q{For how long has the innovation had substantial impact on (ie. measurably improved) your organisation's performance?} do
          ref 'B 1'
          required
          context %Q{
            <p>Your answer here will determine whether you are assessed for outstanding innovation (an award valid for
             two years) or continuous innovation (valid for five years).</p>
          }
          option '2 to 4', '2-4 years'
          option '5 plus', '5 years or more'
        end

        financial_year_dates :financial_year_dates, 'Please select your financial year end dates:' do
          ref 'B 2'
        end

        number :employees, 'State the number of people employed by the company for each year of your entry.' do
          ref 'B 3'
          required
          context %Q{
            <p>State the number of full-time employees at the year-end, or the average for the 12 month period.
            Part-time employees should be expressed in full-time equivalents.</p>
          }
          style :small
          min 2
        end

        options :innovation_part_of, 'My innovation is an integral part of' do
          ref 'B 4'
          required
          option 'entire business', 'The entire business'
          option 'single product or service', 'A single product or service'
        end

        by_years :total_turnover, 'Total turnover' do 
          header 'Company Financials'
          header_context '<p>These figures should be for your entire organisation.</p>'
          ref 'B 5'
          required
        end

        by_years :exports, 'of which exports' do 
          ref 'B 5.1'
          required
          context %Q{<p>Please enter '0' if you had none.</p>}
        end

        by_years :net_profit, 'Net profit after tax but before dividends' do 
          ref 'B 5.2'
          required
        end

        by_years :total_net_assets, 'Total net assets' do 
          ref 'B 5.3'
          required
          context %Q{<p>As per your balance sheet. Total assets (fixed and current), less liabilities (current and long-term).}
        end

        textarea :drops_in_turnover, "Explain any drops in turnover, export sales, total net assets and net profits, as well as any losses made." do
          ref 'B 5.4'
          rows 5
          words_max 200
        end
 
        by_years :units_sold, 'Number of units/contracts sold' do 
          header 'Product/Service Financials'
          
          ref 'B 6'
          required
        end

        by_years :sales, 'Sales' do 
          ref 'B 6.1'
          required
        end

        by_years :sales_exports, 'of which exports' do 
          ref 'B 6.2'
          context %Q{<p>Please enter '0' if you had none.</p>}
          required
        end

        by_years :sales_royalties, 'of which royalties or licenses' do 
          ref 'B 6.3'
          context %Q{<p>Please enter '0' if you had none.</p>}
          required
        end

        textarea :drops_in_sales, "Explain any drops in sales" do
          ref 'B 6.4'
          rows 5
          words_max 300
        end

        options :estimated_figures, 'Are any of these figures estimated?' do
          ref 'B 6.5'
          yes_no
        end

        textarea :estimates_use, 'Explain the use of estimates, and how much of these are actual receipts or firm orders.' do
          conditional :estimated_figures, :yes
          rows 5
          words_max 200
        end

        textarea :financial_comments, 'Additional comments (optional)' do
          ref 'B 6.6'

          rows 5
          words_max 100
        end

        by_years :avg_unit_price, 'Average unit selling price/contract value' do 
          ref 'B 7'
          required
        end

        textarea :avg_unit_price_desc, 'Explain your unit selling prices/contract values, highlighting any changes over the above periods.' do
          rows 5
          words_max 200
        end

        by_years :avg_unit_cost_self, 'Cost, to you, of a single unit/contract' do 
          ref 'B 8'
          required
        end

        textarea :costs_change_desc, 'Explain your unit/ contract costs, highlighting any changes over the above periods.' do
          required
          rows 5
          words_max 200
        end

        textarea :innovation_performance, 'Describe how, when, and to what extent the innovation improved the commercial perfmormance of your business. Also explain any cost savings you made as a result of the innovation.' do
          ref 'B 9'
          required
          rows 5
          words_max 300
        end 

        textarea :investments_details, 'Please enter details of all the investments made in your innovation, and the years when they were made. Include investments made both during and prior to your entry period.' do
          ref 'B 10'
          required
          rows 5
          words_max 300
        end

        textarea :roi_details, 'How long did it take the investment indicated above to be repaid? When and how was this repayment achieved?' do
          ref 'B 10.1'
          required
          rows 5
          words_max 300
        end
      }
    end
  end
end
