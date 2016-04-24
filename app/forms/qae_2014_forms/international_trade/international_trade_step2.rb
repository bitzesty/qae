
class QAE2014Forms
  class << self
    def trade_step2
      @trade_step2 ||= proc do
        header :your_internation_trade_header, "" do
          context %(
            <p>
              This section gives you the opportunity to present the detail of your products/services
              nd to give us the evidence of its commercial impact on your business that will enable
              us to assess your application.
            </p>
            <p>
              Please try to avoid using technical jargon in this section.
            </p>
          )
        end

        header :trade_desc_whole_header, "Describe your business as a whole" do
          ref "B 1"
        end

        textarea :trade_overall_growth_strategy, "Explain your overall growth strategy." do
          sub_ref "B 1.1"
          classes "sub-question"
          required
          rows 5
          words_max 500
        end

        textarea :trade_overall_importance, "Explain the overall importance of exporting to your company." do
          sub_ref "B 1.2"
          classes "sub-question"
          required
          rows 5
          words_max 500
        end

        textarea :trade_brief_history, "Provide a brief history of your company, corporate targets and direction." do
          sub_ref "B 1.3"
          classes "sub-question"
          required
          rows 5
          words_max 500
        end

        textarea :trade_goods_briefly, "Briefly describe each type of goods/services you sell internationally." do
          sub_ref "B 1.4"
          classes "sub-question"
          required
          context %{
            <p>
              This summary will be used in publicity material if your application is successful.
            </p>
          }
          rows 2
          words_max 15
        end

        dropdown :trade_goods_amount, "How many types of goods/services make up your international trade?" do
          ref "B 2"
          required
          context %(
            <p>
              If you have more than 5, please try to group them into fewer types of goods/services.
            </p>
          )
          option "", "Select"
          option "1", "1"
          option "2", "2"
          option "3", "3"
          option "4", "4"
          option "5", "5"
        end

        by_trade_goods_and_services_label :trade_goods_and_services_explanations, "Briefly describe each type of good/service you trade." do
          classes "sub-question word-max-strict"
          sub_ref "B 2.1"
          required
          context %(
            <p>
              If relevant, give details of material used or end use. e.g. 'design and manufacture of bespoke steel windows and doors'. Your percentage answers below should add up to 100.
            </p>
          )
          rows 2
          words_max 15
          min 0
          max 100
          conditional :trade_goods_amount, :true
        end

        textarea :trade_plans_desc, "Describe your international and domestic trading strategies (plans), their vision/objectives for the future, their method of implementation, and how your actual performance compared to the plans set out." do
          ref "B 3"
          required
          context %{
            <p>
              Include for example: your overseas market structure,
              comparisons between domestic and international strategies,
              treatment of different markets (linking to top performing markets),
              market research, market development,
              routes to market, after sales and technical advice,
              activities to sustain/grow markets,
              staff language training, export practices, overseas distributors,
              inward/outward trade missions, trade fairs and visits to existing/potential markets.
              Make sure you explain how your actual performance compares to your planned performance.
            </p>
          }
          rows 5
          words_max 800
        end

        header :overseas_markets_header, "Overseas Markets" do
          ref "B 4"
          context %{
            <p>
              If applicable, demonstrate why penetration of a particular market represents a
              significant achievement: for example are you the first, leading, fastest growing
              UK exporter to an overseas market? How does your performance compare with other
              companies operating in your sector or overseas market?
            </p>
          }
        end

        textarea :markets_geo_spread, "Describe the geographical spread of your overseas markets." do
          required
          sub_ref "B 4.1"
          classes "sub-question"
          context %{
            <p>
              Include evidence of how you segment and manage geographical regions to demonstrate
              your company’s focus. Please supply market share information.
            </p>
          }
          rows 5
          words_max 500
        end

        textarea :top_overseas_sales, "What percentage of total overseas sales was made to each of your top 5 overseas markets (ie. individual countries) during the final year of your entry?" do
          classes "sub-question"
          sub_ref "B 4.2"
          required
          rows 5
          words_max 200
        end

        textarea :identify_new_overseas, "Identify new overseas markets established during your period of entry, and their contribution to total overseas sales." do
          classes "sub-question"
          sub_ref "B 4.3"
          required
          rows 5
          words_max 300
        end

        textarea :trade_factors, "Describe any special challenges affecting your trade in goods or services, and how you overcame them." do
          ref "B 5"
          required
          rows 5
          words_max 200
        end
      end
    end
  end
end
