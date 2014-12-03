class QAE2014Forms
  class << self

  def innovation
    @innovation ||= QAEFormBuilder.build 'Apply for the innovation award' do

      step "Company Information" do

        text :company_name, 'Full/legal name of your business' do
          required
          ref 'A 1'
          help "What name should I write?", %Q{
              <p>Your answer should reflect the title registered with Companies House. If applicable, include 'trading as', or any other name by which the business is known.</p>
          }
        end

        options :principal_business, 'Does your business operate as a principal?' do
          required
          ref 'A 2'
          context %Q{
            <p>We recommend that you apply as a principal. A principal invoices its customers (or their buying agents) and is the body to receive those payments.</p>
          }
          yes_no
        end

        textarea :invoicing_unit_relations,
          'Please explain the arrangements made, and your relationship with the invoicing unit.' do
          required
          conditional :principal_business, :no
          words_max 100
          chars_max 600
          rows 5
        end

        number :registration_number, 'Company/Charity Registration Number' do
          required
          ref 'A 3'
          help 'What if I do not have a Company/Charity Registration number?', %Q{
            <p>Please enter 'N/A' if this is not applicable. If an unregistered subsidiary, please enter your parent company's number.</p>
          }
        end

        date :started_trading, 'Date started trading' do
          required
          ref 'A 4'
          context '<p>Businesses which began trading after 01/10/2012 are not eligible for this award.</p>'
        end

        options :queen_award_holder, %Q{Are you a current Queen's Award holder (2010-2014)?} do
          required
          ref 'A 5'
          yes_no
        end

        award_holder :queen_award_holder_details, "List the Queen's Award(s) you currently hold" do
          ref 'A 5.1'

          conditional :queen_award_holder, :yes

          category :innovation, 'Innovation'
          category :international_trade, 'International Trade'
          category :sustainable_development, 'Sustainable Development'

          year 2010
          year 2011
          year 2012
          year 2013
          year 2014
        end

        options :business_name_changed, 'Has the name of your business changed since your previous entry?' do
          ref 'A 5.2'

          conditional :queen_award_holder, :yes

          yes_no
        end

        previous_name :previous_business_name, '' do
          conditional :business_name_changed, :yes
        end

        options :other_awards_won, 'Have you won any other business or enterprise awards in the past?' do
          ref 'A 6'
          yes_no
        end

        textarea :other_awards_desc, 'Please describe them' do
          context '<p>Only enter the awards you consider most notable.</p>'
          conditional :other_awards_won, :yes
          rows 5
          chars_max 1800
          words_max 300
        end

        options :joint_entry, 'Is this entry made jointly with any other organisation(s)?' do
          ref 'A 7'
          required
          help "Should my entry be a joint entry?", %Q{
            <p>If the business producing or marketing a product, providing a service or using a technology is separate from the unit which developed it, either or both may be eligible according to the contribution made, and whether it helped them achieve commercial success. For a joint entry, each organisation should submit separate, cross-referenced, entry forms.</p>
          }
          yes_no
        end

        text :joint_entry_names, 'Please enter their name(s)' do
          required
          conditional :joint_entry, :yes
          style :largest
        end

        address :principal_address, 'Principal address of your business' do
          required
          ref 'A 8'
        end

        text :website_url, 'Website URL' do
          required
          ref 'A 9'
          type :url
        end

        dropdown :business_sector, 'Business Sector' do
          required
          ref 'A 10'
          option '', ''
          option :other, 'Other'
        end

        text :business_sector_other, 'Please specify' do
          required
          conditional :business_sector, :other
        end

        head_of_business :head_of_business, 'Head of your business' do
          required
          ref 'A 11'
        end

        text :head_job_title, 'Job title / Role in the organisation' do
          required
          ref 'A 11.1'
        end

        text :head_email, 'Email address' do
          required
          ref 'A 11.2'
          type :email
        end

        options :is_division, 'Are you a division, branch or subsidiary?' do
          ref 'A 12'
          yes_no
        end

        text :parent_company, 'Name of immediate parent company' do
          conditional :is_division, :yes
        end

        dropdown :parent_company_country, 'Country of immediate parent company' do
          conditional :is_division, :yes
          QAE2014Forms.countries.each do |country|
            option country, country
          end
        end

        options :parent_ultimate_control, 'Does the immediate parent company have ultimate control?' do
          ref 'A 12.1'
          conditional :is_division, :yes
          yes_no
        end

        text :ultimate_control_company, 'Name of organisation with ultimate control' do
          conditional :parent_ultimate_control, :no
        end

        dropdown :ultimate_control__company_country, 'Country of organisation with ultimate control' do
          conditional :parent_ultimate_control, :no
          QAE2014Forms.countries.each do |country|
            option country, country
          end
        end

        upload :org_chart, 'Upload an organisational chart (optional).' do
          ref 'A 12.2'
          context %Q{
            <p>It must be one file of less than 5MB, in either MS Word Document, PDF or JPG formats.</p>
          }
          conditional :is_division, :yes
        end

      end

      step 'Commercial Performance' do

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
          chars_max 1200
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
          chars_max 1800
          words_max 300
        end

        options :estimated_figures, 'Are any of these figures estimated?' do
          ref 'B 6.5'
          yes_no
        end

        textarea :estimates_use, 'Explain the use of estimates, and how much of these are actual receipts or firm orders.' do
          conditional :estimated_figures, :yes
          rows 5
          chars_max 1200
          words_max 200
        end

        textarea :financial_comments, 'Additional comments (optional)' do
          ref 'B 6.6'

          rows 5
          chars_max 600
          words_max 100
        end

        by_years :avg_unit_price, 'Average unit selling price/contract value' do 
          ref 'B 7'
          required
        end

        textarea :avg_unit_price_desc, 'Explain your unit selling prices/contract values, highlighting any changes over the above periods.' do
          rows 5
          chars_max 1200
          words_max 200
        end

        by_years :avg_unit_cost_self, 'Cost, to you, of a single unit/contract' do 
          ref 'B 8'
          required
        end

        textarea :costs_change_desc, 'Explain your unit/ contract costs, highlighting any changes over the above periods.' do
          required
          rows 5
          chars_max 1200
          words_max 200
        end

        textarea :innovation_performance, 'Describe how, when, and to what extent the innovation improved the commercial perfmormance of your business. Also explain any cost savings you made as a result of the innovation.' do
          ref 'B 9'
          required
          rows 5
          chars_max 1800
          words_max 300
        end 

        textarea :investments_details, 'Please enter details of all the investments made in your innovation, and the years when they were made. Include investments made both during and prior to your entry period.' do
          ref 'B 10'
          required
          rows 5
          chars_max 1800
          words_max 300
        end

        textarea :roi_details, 'How long did it take the investment indicated above to be repaid? When and how was this repayment achieved?' do
          ref 'B 10.1'
          required
          rows 5
          chars_max 1800
          words_max 300
        end

      end

      step 'Description of Goods or Services' do

        textarea :innovation_desc_short, 'Briefly describe your product/service/intiative' do
          ref 'C 1'
          required
          context %Q{
            <p>e.g. 'innovation in the production of injectable general anaesthetic.'</p>
          }
          rows 1
          chars_max 90
          words_max 15
        end

        textarea :innovation_desc_long, 'Describe your innovative product/service/initiative in detail' do
          ref 'C 1.1'
          required
          context %Q{
            <p>Describe the product/service/intitative itself, explain any aspect(s)
            you believe innovative, and why you believe it is innovative: consider
            its uniqeueness and the challenges you had to overcome. Also explain how
            it fits within the overall business e.g. is it your sole product.</p>
          }
          rows 5
          chars_max 4800
          words_min 500
          words_max 800
        end

        textarea :innovation_context, 'Describe the context of your innovation, why and how it came about.' do
          ref 'C 2'
          required
          context %Q{
            <p>Outline the disadvantages, if any, of your own/competing
            products/services/intiatives prior to the innovation. Or otherwise, how you
            identified a gap in the market.</p>
          }
          rows 5
          chars_max 3000
          words_min 300
          words_max 500
        end

        textarea :innovation_overcomes_issues, "Discuss the degree to which your innovation overcomes any issues, and any special difficulties surmounted in doing so." do
          ref 'C 3'
          required
          rows 5
          chars_max 4800
          words_min 500
          words_max 800
        end

        textarea :innovation_befits_details, "Give details of benefits received by your customers and your business as a result of the innova|ny special difficulties surmounted in doing so." do
          ref 'C 4'
          required
          context %Q{
            <p>e.g. increased efficiency, reduction in costs,
            design/production/marketing/distribution improvements,
            better after-sales support, reduced downtime or increased reliability.
            You can also include testimonials to support your claim.</p>
          }
          rows 5
          chars_max 4800
          words_min 500
          words_max 800 
        end

        textarea :innovation_competitors, "Identify and describe any products/services/initiatives made by other organisations that compete with your innovation, and explain how your innovation differs." do
          ref 'C 5'
          required
          rows 5
          chars_max 1800
          words_max 300
        end

        options :innovation_any_contributors, 'Did any external organisation or individiual contribute to this product/service/initiative?' do
          ref 'C 6'
          required
          yes_no
        end

        textarea :innovation_contributors, 'Please enter their name(s) and explain their contribution(s).' do
          required
          conditional :innovation_any_contributors, :yes
          rows 5
          chars_max 3000
          words_max 500
        end

        options :innovation_contributors_aware, 'Are they aware that you are applying for this award?' do
          ref 'C 6.1'
          required
          conditional :innovation_any_contributors, :yes
          yes_no
          option :some, 'Some are aware'
        end

        options :innovation_under_license, 'Is the product/service/initiative under license from another organisation?' do
          ref 'C 7'
          context %Q{
            <p>Include associates of the business.</p>
          }
          yes_no
        end

        textarea :innovation_license_terms, 'Briefly describe the licensing arrangement.' do
          required
          conditional :innovation_under_license, :yes
          rows 5
          chars_max 600
          words_max 100
        end

        options :innovations_grant_funding, 'Have you received any grant funding to support this innovation?' do
          ref 'C 8'
          required
          yes_no
        end

        textarea :innovation_grant_funding_sources, "Please give details of date(s), source(s) and level(s) of funding." do
          required
          conditional :innovations_grant_funding, :yes
          rows 5
          chars_max 1800
          words_max 300
        end

        number :innovation_years, 'How long has it been since the product/service/initiative was released into the marketplace?' do
          required
          ref 'C 9'
          max 100
          unit 'years'
        end

        options :innovation_released_by_applicant, "Was the product/service/intiative released by you?" do
          ref 'C 9.1'
          required
          yes_no
        end

        number :innovation_years_by_applicant, 'How many years have you had it in the marketplace?' do
          required
          conditional :innovation_released_by_applicant, :no
          max 100
          unit 'years'
        end

        textarea :innovation_additional_comments, 'Additional comments (optional)' do
          ref 'C 9.2'
          rows 5
          chars_max 1200
          words_max 200
        end

        materials :innovation_materials, 'If there is additional material you feel would help us to assess your entry then you can add up to 4 files or links here.' do
          ref 'C 10'
          context %Q{
            <p>We cannot guarantee these will be reviewed, so inlcude any
            vital information within the form</p>
            <p>You may upload files of less than 5mb each in either MS Word Document,
            PDF, MS Excel Spreadsheet or MS Powerpoint Presentation formats.
            Or MP4 (video) files of up to TODOmb.</p>
          } # TODO!
          help 'Information we will not review', %Q{
            <p>We will not consider business plans, annual accounts or
            company policy documents. Additional materials should not be used
            as a substitue for completing sections of the form.</p>
          }
        end
      end

    end
  end

  end
end

