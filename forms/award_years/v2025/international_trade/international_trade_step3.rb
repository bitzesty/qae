# -*- coding: utf-8 -*-
class AwardYears::V2025::QaeForms
  class << self
    def trade_step3
      @trade_step3 ||= proc do
        about_section :your_internation_trade_header, "" do
          section "your_international_trade"
        end

        textarea :trade_business_as_a_whole, "Describe your business as a whole." do
          classes "word-max-strict"
          sub_ref "C 1"
          required
          rows 5
          words_max 500
        end

        textarea :trade_brief_history, "Provide a brief history of your company, corporate targets and direction." do
          classes "sub-question word-max-strict"
          sub_ref "C 1.1"
          required
          rows 5
          words_max 500
        end

        textarea :trade_overall_importance, "Explain the overall importance of exporting to your company." do
          classes "sub-question word-max-strict"
          ref "C 2"
          required
          rows 5
          words_max 500
        end

        textarea :trade_description_short, "Provide a one-line description of your international trade." do
          classes "sub-question word-max-strict"
          sub_ref "C 2.1"
          context %(
            <p>
              This summary will be used in publicity material if your application is successful.
            </p>
            <p>
              For example:
            </p>
            <ul>
              <li>The leading source of agricultural market intelligence, supporting the advancement of the global food chain.</li>
              <li>Cross-border eCommerce retail and technology group enabling merchants of all sizes to access China.</li>
              <li>World-leading marine equipment for the deployment of subsea infrastructure across traditional and renewable energy sectors.</li>
            </ul>
          )
          pdf_context %(
            This summary will be used in publicity material if your application is successful.

            For example:

            \u2022 The leading source of agricultural market intelligence, supporting the advancement of the global food chain.
            \u2022 Cross-border eCommerce retail and technology group enabling merchants of all sizes to access China.
            \u2022 World-leading marine equipment for the deployment of subsea infrastructure across traditional and renewable energy sectors.
          )
          required
          rows 1
          words_max 15
        end

        checkbox_seria :application_relate_to_header, "This entry relates to:" do
          sub_ref "C 2.2"
          required
          context %(
            <p>Select all that apply.</p>
          )
          check_options [
            ["products", "Products"],
            ["services", "Services"]
          ]
          application_type_question true
        end

        by_trade_goods_and_services_label :trade_goods_and_services_explanations, "List and briefly describe each product or service you export." do
          classes "sub-question word-max-strict"
          sub_ref "C 2.3"
          required
          context %(
            <p>
              If you have more than five products or services, group them, so that they don’t exceed five.
            </p>
            <p>
              If relevant, give details of material used or end use, for example: 'design and manufacture of bespoke steel windows and doors'. Your percentage answers below should add up to 100.
            </p>
          )
          additional_pdf_context %(
            You will need to complete this information for each product or service.
          )
          rows 2
          product_limit 5
          words_max 15
          min 0
          max 100
        end

        textarea :trade_plans_desc, "Describe your international trade strategy." do
          ref "C 3"
          classes "word-max-strict"
          required
          context %(
            <p>
              Make sure your answer includes:
            </p>
            <ul>
              <li>Your vision and objectives for the future.</li>
              <li>Your overall growth plans and the links and importance between your international and domestic trading strategies (plans).</li>
              <li>Your method of implementation of your international strategy.
            </ul>
            <p>
              Areas you may want to mention in your answer: your overseas market structure, treatment of different markets, market research, market development, routes to market, after-sales and technical advice, activities to sustain/grow markets, export practices, overseas distributors, inward and outward trade missions and market visits.
            </p>
          )
          pdf_context %(
            <p>
              Make sure your answer includes:

              \u2022 Your vision and objectives for the future.

              \u2022 Your overall growth plans and the links and importance between your international and domestic trading strategies (plans).

              \u2022 Your method of implementation of your international strategy.

              Areas you may want to mention in your answer: your overseas market structure, treatment of different markets, market research, market development, routes to market, after-sales and technical advice, activities to sustain/grow markets, export practices, overseas distributors, inward and outward trade missions and market visits.
            </p>
          )
          rows 5
          words_max 800
        end

        textarea :actual_planned_performance_comparison, "Please explain how your actual performance compared to your planned performance as outlined in question C3." do
          sub_ref "C 3.1"
          classes "sub-question word-max-strict"
          required
          rows 3
          words_max 250
        end

        header :overseas_markets_header, "Overseas Markets" do
          ref "C 4"
          context %(
            <p class="govuk-body">
              If applicable, demonstrate why penetration of a particular market represents a significant achievement. For example, are you the first, leading, fastest growing UK exporter to an overseas market? How does your performance compare with other companies operating in your sector or overseas market?
            </p>
          )
        end

        textarea :markets_geo_spread, "Describe the geographical spread of your overseas markets." do
          required
          sub_ref "C 4.1"
          classes "sub-question word-max-strict"
          context %(
            <p>
              Include evidence of how you segment and manage geographical regions to demonstrate your company's focus. Please supply market share information.
            </p>
          )
          rows 3
          words_max 300
        end

        textarea :top_overseas_sales, "What percentage of total overseas sales was made to each of your top 5 overseas markets (individual countries) during the final year of your entry?" do
          classes "sub-question word-max-strict"
          sub_ref "C 4.2"
          required
          rows 1
          words_max 100
        end

        textarea :identify_new_overseas, "Identify new overseas markets established during your period of entry and their contribution to total overseas sales." do
          classes "sub-question word-max-strict"
          sub_ref "C 4.3"
          required
          rows 3
          words_max 250
        end

        checkbox_seria :operate_overseas, "How do you run your overseas operations?" do
          ref "C 5"
          required
          context %(
            <p>Select all that apply.</p>
          )
          check_options [
            ["franchise", "As a franchise"],
            ["other", "Other business models"]
          ]
        end

        textarea :operate_model_benefits, "Explain your franchise or other business models and the rationale for this. Describe the benefits this brings to the UK." do
          classes "sub-question word-max-strict"
          sub_ref "C 5.1"
          required
          rows 3
          words_max 300
        end

        textarea :trade_factors, "Describe any special challenges affecting your trade due to COVID-19, and how you overcame them." do
          ref "C 6"
          classes "word-max-strict"
          required
          context %(
            <ul>
              <li>Describe the impact COVID-19 has had on your business and its performance.</li>
              <li>How have you adapted or mitigated it, and with what results?</li>
            </ul>
          )
          pdf_context %(
            <p>
              \u2022 Describe the impact COVID-19 has had on your business and its performance.

              \u2022 How have you adapted or mitigated it, and with what results?
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :economic_uncertainty_response, "Explain how your business has been responding to the economic uncertainty experienced nationally and globally in recent years (due to factors other than COVID-19)." do
          sub_ref "C 6.1"
          classes "sub-question word-max-strict"
          required
          context %(
            <ul>
              <li>How have you adapted to or mitigated the impacts of recent national and global market conditions?</li>
              <li>How are you planning to respond in the year ahead? This could include opportunities you have identified.</li>
              <li>Provide any contextual information or challenges you would like the assessors to consider.</li>
            <ul>
          )
          pdf_context %(
            <p>
              \u2022 How have you adapted to or mitigated the impacts of recent national and global market conditions?
              \u2022 How are you planning to respond in the year ahead? This could include opportunities you have identified.
              \u2022 Provide any contextual information or challenges you would like the assessors to consider.
            </p>
          )
          words_max 350
        end

        options :received_grant, "Did you receive any grant funding to support your export products/services?" do
          ref "C 7"
          required
          yes_no
          context %(
            <p>
              We ask this to help us carry out due diligence if your application is shortlisted.
            </p>
          )
        end

        textarea :funding_details, "Please provide dates, sources and levels of funding." do
          classes "sub-question word-max-strict"
          sub_ref "C 7.1"
          required
          rows 2
          words_max 200
          conditional :received_grant, "yes"
        end
      end
    end
  end
end
