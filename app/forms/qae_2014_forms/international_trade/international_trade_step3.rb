class QAE2014Forms
  class << self
    def trade_step3
      @trade_step3 ||= Proc.new {
        textarea :trade_desc_whole, 'Describe your business as a whole' do
          ref 'C 1'
          required
          context %Q{
            <p>Include a brief history, your overall growth strategy, corporate targets/direction/vision, and a full description of the products/services you export.</p>
          }
          rows 5
          words_max 500
        end

        options :trade_goods_amount, 'How many types of goods/services make up your international trade?' do
          ref 'C 2'
          required
          option '1', '1'
          option '2', '2'
          option '3', '3'
          option '4', '4'
          option '5', '5'
        end

        textarea :goods_desc_short, 'Brief description of the goods and/or services being traded overseas' do
          classes "sub-question"
          required
          context %Q{
            <p>e.g. 'design and manufacture of bespoke steel windows and doors'. If relevant, give details of material used or end use. </p>
          }
          rows 2
          words_max 15
        end

        number :employees, '% of your total overseas trade' do
          classes "sub-question"
        end

        textarea :trade_plans_desc, 'Describe your international and domestic trading strategies (plans), their vision/objectives for the future, their method of implementation, and how your actual performance compared to the plans set out.' do
          ref 'C 3'
          required
          context %Q{
            <p>Include, for example, comparisons between domestic and international strategies, treatment of different markets (linking to top performing markets), market research, market development, routes to market, after sales and technical advice, staff language training, export practices, overseas distributors, inward/outward trade missions, trade fairs and visits to existing/potential markets. Make sure you explain how your actual performance compares to your planned performance.</p>
          }
          rows 5
          words_max 800
        end

        header :overseas_markets_header, "Overseas Markets" do
        end

        textarea :markets_geo_spread, "Describe the geographical spread of your overseas markets." do
          ref 'C 4'
          required
          context %Q{
            <p>Include evidence of how you segment and manage geographical regions. Please supply market share information. </p>
          }
          rows 5
          words_max 500
        end

        textarea :top_overseas_sales, "State the percentage of total overseas sales made to each of your top 5 overseas countries during the final year of your entry." do
          classes "sub-question"
          required
          rows 5
          words_max 200
        end

        textarea :identify_new_overseas, "Identify new overseas markets established during your period of entry, and their contribution to total overseas sales." do
          classes "sub-question"
          required
          rows 5
          words_max 300
        end

        textarea :trade_factors, "Give details of any special challenges affecting your trade in goods or services, and how you overcame them." do
          ref 'C 5'
          required
          rows 5
          words_max 200
        end

        materials :trade_materials, 'If there is additional material you feel would help us to assess your entry then you can add up to 4 files or links here.' do
          ref 'C 7'
          context %Q{
            <p>We can't guarantee these will be reviewed, so inlcude any vital information within the form.</p>
            <p>You may upload files of less than 5mb each in either MS Word Document, PDF, MS Excel Spreadsheet or MS Powerpoint Presentation formats. Or MP4 (video) files of up to TODOmb.</p>
          } # TODO!
          help 'Information we will not review', %Q{
            <p>We will not consider business plans, annual accounts or company policy documents. Additional materials should not be used as a substitue for completing sections of the form.</p>
          }
        end
      }
    end
  end
end
