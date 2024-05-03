class AwardYears::V2019::QaeForms
  class << self
    def development_step2
      @development_step2 ||= proc do
        header :development_b_section_header, "" do
          context %(
            <p>
              This section enables you to present the details of your product, service or management approach and to give us the evidence about your activities, leadership and achievements that will allow us to assess your application.
            </p>
            <p>
              Please try to avoid using technical jargon in this section.
            </p>
          )
        end

        checkbox_seria :application_relate_to, "This entry relates to:" do
          ref "B 1"
          required
          context %(
            <p>Select all that apply.</p>
          )
          check_options [
            ["product", "A product"],
            ["service", "A service"],
            ["management_approach", "A management approach"],
          ]
          application_type_question true
        end

        textarea :development_management_approach_briefly, "Briefly describe your product, service or management approach." do
          classes "sub-question word-max-strict"
          ref "B 1.1"
          required
          context %(
            <p>
              If more than one, please make sure you cover all of them.
            </p>
            <p>
              This will be used in publicity material if your application is successful.
            </p>
            <p>
              For example:
            </p>
            <ul>
              <li>
                Working with organisations to produce the highest quality printed material with the lightest environmental impact.
              </li>
              <li>
                Product and ingredient certification, business services and public awareness for fair and sustainable trade.
              </li>
              <li>
                Own, manage and develop an environmentally friendly commercial property, focused on UK retail offices.
              </li>
            </ul>
          )

          pdf_context %(
            <p>
              If more than one, please make sure you cover all of them.
            </p>
            <p>
              This will be used in publicity material if your application is successful.
            </p>
            <p>
              For example:
            </p>
            <p>
              \u2022 Working with organisations to produce the highest quality printed material with the lightest environmental impact.

              \u2022 Product and ingredient certification, business services and public awareness for fair and sustainable trade.

              \u2022 Own, manage and develop an environmentally friendly commercial property, focused on UK retail offices.
            </p>
          )
          rows 2
          words_max 15
        end

        textarea :development_desc_long,
                 "Summarise your product, service or management approach specifically concerning your core business, and any practices followed as a result of the operations or requirements of the wider organisation/parent company." do
          classes "sub-question word-max-strict"
          ref "B 1.2"
          required
          context %(
            <p>
              <strong>Please note: If you are applying for a management approach only, the sustainability of your product/service will also be taken into account.</strong>
            </p>
            <p>
              If more than one product, service or management approach, please make sure you cover all of them. Include a brief description of their origin and development.
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :development_desc_short,
                 "Describe how you demonstrate leadership regarding influencing staff or managing the resources that are important to your application and how you look to embed these principles with your suppliers and customers." do
          classes "word-max-strict"
          ref "B 2"
          required
          context %(
            <p>
              Please summarise any plans, policies, strategies that you have in place that demonstrate your leadership approach within your organisation and which drive your relationships with your partners.
            </p>
            <p>
              For example, you may wish to demonstrate how you:
            </p>
            <ul>
              <li>
                Have achieved any specific successes and outcomes, such as developing an innovative new product or process delivering environmental benefits (above), or seeing sustainable development outcomes embedded in your organisation, supply chain or community.
              </li>
              <li>
                Follow principles of good governance, openness and consultation with regards to customers, suppliers and staff.
              </li>
              <li>
                Have embedded ethical business principles and, where appropriate, have actively opposed corruption and unfair practices or challenged those with a detrimental impact on the environment.
              </li>
              <li>
                Systematically promote sustainable development - for example, by using indicators, targets, policies and management processes to enable you to demonstrate and measure progress and success.
              </li>
              <li>
                Take part in and commit to relevant accredited and verified schemes such as British Standards and ISO.
              </li>
              <li>
                Create management innovation. For example, develop innovative ways to engage employees, local communities and stakeholders in sustainable development, or have reward schemes for employees with good environmental and social performance.
              </li>
            </ul>
            <p>
              Please specify the timescale over which your sustainable development performance has been or will be sustained.
            </p>
          )

          pdf_context %(
            <p>
              Please summarise any plans, policies, strategies that you have in place that demonstrate your leadership approach within your organisation and which drive your relationships with your partners.
            </p>
            <p>
              For example, you may wish to demonstrate how you:
            </p>
            <p>
              \u2022 Have achieved any specific successes and outcomes, such as developing an innovative new product or process delivering environmental benefits (above), or seeing sustainable development outcomes embedded in your organisation, supply chain or community.

              \u2022 Follow principles of good governance, openness and consultation with regards to customers, suppliers and staff.

              \u2022 Have embedded ethical business principles and, where appropriate, have actively opposed corruption and unfair practices or challenged those with a detrimental impact on the environment.

              \u2022 Systematically promote sustainable development - for example, by using indicators, targets, policies and management processes to enable you to demonstrate and measure progress and success.

              \u2022 Take part in and commit to relevant accredited and verified schemes such as British Standards and ISO.

              \u2022 Create management innovation. For example, develop innovative ways to engage employees, local communities and stakeholders in sustainable development, or have reward schemes for employees with good environmental and social performance.
            </p>
            <p>
              Please specify the timescale over which your sustainable development performance has been or will be sustained.
            </p>
          )
          rows 8
          words_max 750
        end

        header :provide_evidence_header,
               "Where possible, provide evidence of your product, service or management approach's contribution to each of the outcomes of sustainable development below." do
          ref "B 3"
          context %(
            <p>
              You should demonstrate good performance in all areas and outstanding performance in at least one area. If your contribution is not outstanding in all areas, please describe the actions you are taking to improve outcomes in those areas.
            </p>
          )
        end

        textarea :environmental_contribution, "Explain how it contributes to environmental outcomes of sustainable development." do
          required
          classes "sub-question"
          sub_ref "B 3.1"
          context %(
            <p>
             'Environmental outcomes' means respecting the limits of the planet's environment, natural resources and biodiversity, including, where possible, improving the state of the environment.
            </p>
            <p>
              When explaining your contribution to the environmental outcomes of sustainable development, you may find it helpful to consider:
            </p>
            <ul>
              <li>
                The Government’s goals in the 25 Year Environment Plan to improve the environment within a generation.
              </li>
              <li>
                The goal of demonstrating leadership on cleaner economic growth as set out in the Government’s Clean Growth Strategy and Industrial Strategy.
              </li>
            </ul>
            <p>
              Your sustainable development activity might be an activity which helps to deliver:
            </p>
            <ul>
              <li>
                Clean air.
              </li>
              <li>
                Clean and plentiful water.
              </li>
              <li>
                Mitigations and adaptions to climate change.
              </li>
              <li>
                More efficient use of energy and reduced reliance on high carbon energy sources.
              </li>
              <li>
                Thriving plants and wildlife.
              </li>
              <li>
                Reduced risk of harm from environmental hazards such as flooding and drought.
              </li>
              <li>
                More sustainable and efficient use of resources from nature.
              </li>
              <li>
                Enhanced beauty, heritage and engagement with the natural environment.
              </li>
              <li>
                Reduced waste and increased recycling.
              </li>
              <li>
                Management of exposure to chemicals.
              </li>
              <li>
                Improvements to biosecurity.
              </li>
            </ul>
            <p>
              For example, you might wish to demonstrate how you and your suppliers have:
            </p>
            <ul>
              <li>
                Adopted innovative new business models. For example, more ‘circular’ approaches to resource management, reverse logistics or shifting from sales to leasing models.
              </li>
              <li>
                Reduced greenhouse gas emissions, through greater energy efficiency and reduced reliance on fossil fuels.
              </li>
              <li>
                Reduced the amount of waste generated and reduced the environmental impact of outputs.
              </li>
              <li>
                Substituted material inputs for more environmentally sound alternatives.
              </li>
              <li>
                Reduced water consumption.
              </li>
              <li>
                Taken action to encourage customers or the public to reduce their water, energy or other consumption habits, for example, by using less plastic.
              </li>
              <li>
                Protected or enhance the physical environment and its biodiversity on sites that you occupy, those of your supply chain or in your local community.
              </li>
              <li>
                Participated in external activities with environmental benefits – for example, supporting local environmental groups, influencing your sector.
              </li>
              <li>
                Undertaken sustainable, for example - green, procurement.
              </li>
            </ul>
          )

          pdf_context %(
            <p>
             'Environmental outcomes' means respecting the limits of the planet's environment, natural resources and biodiversity, including, where possible, improving the state of the environment.
            </p>
            <p>
              When explaining your contribution to the environmental outcomes of sustainable development, you may find it helpful to consider:
            </p>
            <p>
              \u2022 The Government’s goals in the 25 Year Environment Plan to improve the environment within a generation.

              \u2022 The goal of demonstrating leadership on cleaner economic growth as set out in the Government’s Clean Growth Strategy and Industrial Strategy.
            </p>
            <p>
              Your sustainable development activity might be an activity which helps to deliver:
            </p>
            <p>
              \u2022 Clean air.

              \u2022 Clean and plentiful water.

              \u2022 Mitigations and adaptions to climate change.

              \u2022 More efficient use of energy and reduced reliance on high carbon energy sources.

              \u2022 Thriving plants and wildlife.

              \u2022 Reduced risk of harm from environmental hazards such as flooding and drought.

              \u2022 More sustainable and efficient use of resources from nature.

              \u2022 Enhanced beauty, heritage and engagement with the natural environment.

              \u2022 Reduced waste and increased recycling.

              \u2022 Management of exposure to chemicals.

              \u2022 Improvements to biosecurity.
            </p>
            <p>
              For example, you might wish to demonstrate how you and your suppliers have:
            </p>
            <p>
              \u2022 Adopted innovative new business models. For example, more ‘circular’ approaches to resource management, reverse logistics or shifting from sales to leasing models.

              \u2022 Reduced greenhouse gas emissions, through greater energy efficiency and reduced reliance on fossil fuels.

              \u2022 Reduced the amount of waste generated and reduced the environmental impact of outputs.

              \u2022 Substituted material inputs for more environmentally sound alternatives.

              \u2022 Reduced water consumption.

              \u2022 Taken action to encourage customers or the public to reduce their water, energy or other consumption habits, for example, by using less plastic.

              \u2022 Protected or enhance the physical environment and its biodiversity on sites that you occupy, those of your supply chain or in your local community.

              \u2022 Participated in external activities with environmental benefits – for example, supporting local environmental groups, influencing your sector.

              \u2022 Undertaken sustainable, for example - green, procurement.
            </p>
          )

          rows 5
          words_max 750
        end

        textarea :social_contribution, "Explain how it contributes to social outcomes of sustainable development." do
          classes "sub-question"
          sub_ref "B 3.2"
          required
          context %(
            <p>
              'Social outcomes’ means working towards the needs of people in the present and future communities, promoting well-being, cohesion and equal opportunities.
            </p>
            <p>
              For example, you may wish to demonstrate how you:
            </p>
            <ul>
              <li>
                Create products and services that deliver social value, such as positive nutritional outcomes and health and wellbeing benefits, as well as market-offers that in themselves help build sustainable communities.
              </li>
              <li>
                Promote health and safety for your staff and supply chain, and at the very least meet British Standards or their equivalent, and influence others in the sector to do similar.
              </li>
              <li>
                Promote the wellbeing of staff including helping them to deliver skills which will be of value both inside and outside work.
              </li>
              <li>
                Support local communities - for example, through staff volunteering or sharing of resources, premises and expertise.
              </li>
              <li>
                Engage with local schools, colleges and universities to help increase the life chances of young people.
              </li>
              <li>
                Procure food that meets British or equivalent production standards, and support a healthy balanced diet.
              </li>
              <li>
                Conserve any parts of your environment with historical or cultural importance.
              </li>
            </ul>
          )

          pdf_context %(
            <p>
              'Social outcomes’ means working towards the needs of people in the present and future communities, promoting well-being, cohesion and equal opportunities.
            </p>
            <p>
              For example, you may wish to demonstrate how you:
            </p>
            <p>
              \u2022 Create products and services that deliver social value, such as positive nutritional outcomes and health and wellbeing benefits, as well as market-offers that in themselves help build sustainable communities.

              \u2022 Promote health and safety for your staff and supply chain, and at the very least meet British Standards or their equivalent, and influence others in the sector to do similar.

              \u2022 Promote the wellbeing of staff including helping them to deliver skills which will be of value both inside and outside work.

              \u2022 Support local communities - for example, through staff volunteering or sharing of resources, premises and expertise.

              \u2022 Engage with local schools, colleges and universities to help increase the life chances of young people.

              \u2022 Procure food that meets British or equivalent production standards, and support a healthy balanced diet.

              \u2022 Conserve any parts of your environment with historical or cultural importance.
            </p>
          )
          rows 5
          words_max 750
        end

        textarea :economic_contribution, "Explain how it contributes to economic outcomes of sustainable development." do
          classes "sub-question"
          sub_ref "B 3.3"
          required
          context %(
            <p>
             'Economic outcomes' means building a fair, sustainable economy which provides prosperity and opportunity for all, promotes innovation and encourages lifelong learning.
            </p>
            <p>
              For example, you may wish to demonstrate how you:
            </p>
            <ul>
              <li>
                Have maximised the economic benefits or grown your business while reducing or eliminating your greenhouse gas emissions and reliance on fossil fuels.
              </li>
              <li>
                Have encouraged businesses in your supply chain to reduce their carbon footprint and reliance on fossil fuels.
              </li>
              <li>
                Have implemented sustainable development practices that have helped you to create jobs, especially amongst disadvantaged groups.
              </li>
              <li>
                Have created procurement practices which support the local economy.
              </li>
              <li>
                Have articulated the business case for your organisation to assess, address and report on natural capital risks and opportunities in your operations and supply chains.
              </li>
              <li>
                Encourage and enable staff in your organisation and supply chain to undertake learning and development to improve their skills and life chances, including through formal routes such as apprenticeships and informal on-the-job learning.
              </li>
              <li>
                Are open to new concepts in sustainable development and are finding innovative ways to improve both sustainability and the bottom line, and how you have facilitated environmental or low carbon entrepreneurialism or innovation either as an organisation or in your supply chains.
              </li>
              <li>
                Promote sustainable construction practices.
              </li>
            </ul>
          )

          pdf_context %(
            <p>
             'Economic outcomes' means building a fair, sustainable economy which provides prosperity and opportunity for all, promotes innovation and encourages lifelong learning.
            </p>
            <p>
              For example, you may wish to demonstrate how you:
            </p>
            <p>
              \u2022 Have maximised the economic benefits or grown your business while reducing or eliminating your greenhouse gas emissions and reliance on fossil fuels.

              \u2022 Have encouraged businesses in your supply chain to reduce their carbon footprint and reliance on fossil fuels.

              \u2022 Have implemented sustainable development practices that have helped you to create jobs, especially amongst disadvantaged groups.

              \u2022 Have created procurement practices which support the local economy.

              \u2022 Have articulated the business case for your organisation to assess, address and report on natural capital risks and opportunities in your operations and supply chains.

              \u2022 Encourage and enable staff in your organisation and supply chain to undertake learning and development to improve their skills and life chances, including through formal routes such as apprenticeships and informal on-the-job learning.

              \u2022 Are open to new concepts in sustainable development and are finding innovative ways to improve both sustainability and the bottom line, and how you have facilitated environmental or low carbon entrepreneurialism or innovation either as an organisation or in your supply chains.

              \u2022 Promote sustainable construction practices.
            </p>
          )
          rows 5
          words_max 750
        end

        textarea :sector_leader_desc,
                 "How does the information provided in previous answers demonstrate that you are showing sector-leading sustainability performance?" do
          ref "B 4"
          required
          context %(
            <p>Can you benchmark this performance against other comparable organisations?</p>

            <p>What have you done to address and overcome the most important sustainable development challenges that are specific to your sector?</p>

            <p>Have you pioneered the development of new natural capital markets – for example, in exploring how more revenue streams could be generated to make natural capital assets investable?</p>

            <p>Have any of your operations or sustainability innovations resulted in the UK becoming an international leader in providing knowledge-based goods and services?</p>
          )
          rows 5
          words_max 750
        end

        textarea :name_of_external_organization_or_individual,
                 'Please name the external organisation(s) or individual(s) that contributed to your product, service or management approach, and explain their contributions or enter "N/A".' do
          ref "B 5"
          required
          rows 5
          words_max 400
        end

        options :another_org_licensed, "Is the product, service or management approach under licence from another organisation?" do
          ref "B 6"
          required
          yes_no
        end

        textarea :licensing_agreement, "Briefly describe the licensing arrangement." do
          classes "sub-question"
          sub_ref "B 6.1"
          required
          rows 5
          words_max 100
          conditional :another_org_licensed, :yes
        end

        options :grant_support, "Have you received any grant funding to support this product, service or management approach?" do
          ref "B 7"
          required
          yes_no
          context %(
            <p>
              We ask this in order to help us carry out due diligence if your application is shortlisted.
            </p>
          )
        end

        textarea :grant_details, "Please give details of date(s), source(s) and level(s) of funding." do
          classes "sub-question"
          sub_ref "B 7.1"
          required
          rows 5
          words_max 250
          conditional :grant_support, :yes
        end

        date :development_was_launched_since,
             "Please select the date since when your product, service or management approach has been in commercial operation, production or in progress?" do
          required
          ref "B 8"
          context lambda {
            %(
              <p>
                You are not eligible for this award if it’s after #{AwardYear.start_trading_since(2)} (or after #{AwardYear.start_trading_since(5)} if you are applying for the five-year award).
              </p>
            )
          }
          date_max AwardYear.start_trading_since(2)
        end

        textarea :development_additional_comments, "Additional comments (optional)" do
          classes "sub-question"
          sub_ref "B 8.1"
          rows 5
          words_max 200
        end
      end
    end
  end
end
