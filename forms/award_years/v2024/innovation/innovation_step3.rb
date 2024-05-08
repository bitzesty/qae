# coding: utf-8
class AwardYears::V2024::QaeForms
  class << self
    def innovation_step3
      @innovation_step3 ||= proc do
        about_section :your_innovation_header, "" do
          section "your_innovation"
        end

        header :innovation_background_header, "Innovation background" do
          ref "C 1"
          linkable true
          context %(
            <p class="govuk-body">
              The questions in subsection C1 help the assessors understand the context of your innovation.
            </p>
          )
        end

        checkbox_seria :application_relate_to_header, "This entry relates to:" do
          sub_section :innovation_background_header
          classes "sub-question"
          sub_ref "C 1.1"
          required
          context %(
            <p>
              Select all that apply.
            </p>
          )
          check_options [
            ["product", "A product"],
            ["service", "A service"],
            ["business_model", "A business model or process"],
          ]
          application_type_question true
        end

        textarea :innovation_desc_short, "Provide a one-line description of your innovative product, service, business model or process." do
          sub_section :innovation_background_header
          classes "sub-question word-max-strict"
          sub_ref "C 1.2"
          required
          context %(
            <p>
              This 15-word summary will be used in publicity material if your application is successful.
            </p>
            <p>
              For example:
            </p>
            <ul>
              <li>
                Innovative electro-mechanical downhole power delivery system to avoid the use of explosives or dangerous goods.
              </li>
              <li>
                Integrating digital and personal contact to improve health and safety and detect changing customer needs.
              </li>
              <li>
                High-performance parachute fabric successfully delivering NASA's Perseverance Rover onto the surface of Mars.
              </li>
            </ul>
          )
          pdf_context %(
            <p>
              This 15-word summary will be used in publicity material if your application is successful.
            </p>
            <p>
              For example:
            </p>
            <p>
              \u2022 Innovative electro-mechanical downhole power delivery system to avoid the use of explosives or dangerous goods.

              \u2022 Integrating digital and personal contact to improve health and safety and detect changing customer needs.

              \u2022 High-performance parachute fabric successfully delivering NASA's Perseverance Rover onto the surface of Mars.
            </p>
          )
          rows 1
          words_max 15
        end

        options :description_that_best_reflects_the_type_of_innovation, "Select the description that best reflects the type of your innovation." do
          sub_section :innovation_background_header
          classes "sub-question"
          sub_ref "C 1.3"
          required
          context %(
            <p>
              Please note, both types are equally eligible for the award. Your answer will assist assessors in understanding the nature of the type of innovation.
            </p>
          )
          option "disruptive_innovation", %(
            Disruptive innovation: A new or creative-in-thought innovation that does not seem to have been done before. While having a financial return, it may not yet have secured substantial market impact and did not displace many other firms and products.
          )
          option "continuous_innovation", %(
            Continuous innovation: Innovation that adds a new function or benefit to the existing product, service or business model.
          )
        end

        options :innovation_hold_existing_patent, "Do you hold the existing patent for this innovation?" do
          sub_section :innovation_background_header
          classes "sub-question"
          sub_ref "C 1.4"
          required
          yes_no
        end

        textarea :innovation_hold_existing_patent_details, "Provide a link to your published patent document. If you do not have a patent, please explain the reasons why not." do
          sub_section :innovation_background_header
          classes "sub-question word-max-strict"
          sub_ref "C 1.4.1"
          required
          context %(
            <p>
              This link should be from organisations such as EPO, Google Patents, the US patent office, or the British patent office.
            </p>
            <p>
              If you do not have a patent, please explain how you might protect the market position that you have created. Explain if and why your innovation is hard to copy, for example, market position, trade secrets or design rights.
            </p>
          )
          rows 2
          words_max 100
        end

        options :innovation_conceived_and_developed, "Was the whole of your innovation conceived and developed in the UK?" do
          sub_section :innovation_background_header
          classes "sub-question"
          sub_ref "C 1.5"
          required
          yes_no
        end

        textarea :innovation_other_countries_it_was_developed, "Describe in what other countries and, if applicable, by what parties it was developed." do
          sub_section :innovation_background_header
          classes "sub-question word-max-strict"
          sub_ref "C 1.5.1"
          required
          conditional :innovation_conceived_and_developed, :no
          context %(
            <p>
              Also, if applicable, include an estimate of what proportion of the innovation was developed there.
            </p>
          )
          rows 3
          words_max 200
        end

        options :innovation_joint_contributors, "Is this application part of a joint entry with any contributing organisations?" do
          sub_section :innovation_background_header
          classes "sub-question"
          sub_ref "C 1.6"
          required
          context %(
            <p>
              If two or more organisations made a significant contribution to the product, service, business model or process, you should make a joint entry. Each organisation should submit separate, cross-referenced entry forms.
            </p>
          )
          yes_no
        end

        textarea :innovation_contributors, "Please enter their names." do
          sub_section :innovation_background_header
          classes "sub-question word-max-strict"
          sub_ref "C 1.6.1"
          required
          conditional :innovation_joint_contributors, :yes
          rows 2
          words_max 100
        end

        options :innovation_any_contributors, "Did any external organisations or individuals significantly contribute to your innovation?" do
          sub_section :innovation_background_header
          classes "sub-question"
          sub_ref "C 1.7"
          required
          yes_no
          context %(
            <p>
              Exclude paid suppliers and consultants. Only include organisations that were equal or significant partners.
            </p>
          )
        end

        textarea :innovation_external_contributors, "Name any external organisations or individuals that contributed to your innovation and explain their contributions." do
          sub_section :innovation_background_header
          classes "sub-question word-max-strict"
          sub_ref "C 1.7.1"
          required
          conditional :innovation_any_contributors, :yes
          rows 3
          words_max 200
        end

        options :innovation_contributors_aware, "Are they aware that you are applying for this award?" do
          sub_section :innovation_background_header
          classes "sub-question"
          sub_ref "C 1.7.2"
          required
          conditional :innovation_any_contributors, :yes
          option :yes, "Yes, they are all aware"
          option :no, "No, they are not all aware"
        end

        header :innovation_contributors_aware_header_no, "" do
          classes "application-notice help-notice"
          context %(
            <p class="govuk-body">
              Notifying all contributors can avoid disputes due to the contributors feeling that their contribution was not acknowledged. We, therefore, recommend that you inform all organisations who have contributed to your innovation.
            </p>
          )
          conditional :innovation_any_contributors, :yes
          conditional :innovation_contributors_aware, :no
        end

        textarea :innovation_contributors_why_organisations, "Explain why external organisations or individuals that contributed to your innovation are not all aware of this application." do
          sub_section :innovation_background_header
          classes "sub-question word-max-strict"
          sub_ref "C 1.7.3"
          required
          conditional :innovation_any_contributors, :yes
          conditional :innovation_contributors_aware, :no
          rows 3
          words_max 200
        end

        options :innovation_under_license, "Is your innovation under licence from another organisation?" do
          sub_section :innovation_background_header
          classes "sub-question"
          sub_ref "C 1.8"
          required
          yes_no
        end

        textarea :innovation_license_terms, "Briefly describe the licensing arrangement." do
          sub_section :innovation_background_header
          classes "sub-question word-max-strict"
          sub_ref "C 1.8.1"
          required
          conditional :innovation_under_license, :yes
          rows 2
          words_max 100
        end

        options :innovations_grant_funding, "Have you received any grant funding or made use of any government support, such as an innovation loan, in relation to your innovation?" do
          sub_section :innovation_background_header
          classes "sub-question"
          sub_ref "C 1.9"
          required
          yes_no
          context %(
            <p>
              To receive grant funding or other government support, usually the company must go through a rigorous vetting process, so if you have received any such funding, assessors will find it reassuring. However, many companies self-finance and the assessors appreciate that as well.
            </p>
          )
        end

        textarea :innovation_grant_funding_sources, "Please give details of dates, sources and levels of funding." do
          sub_section :innovation_background_header
          classes "sub-question word-max-strict"
          sub_ref "C 1.9.1"
          required
          conditional :innovations_grant_funding, :yes
          rows 3
          words_max 250
        end


        header :innovation_timeline_header, "Innovation development" do
          ref "C 2"
          linkable true
          context %{
            <p class="govuk-body">
              The questions in subsection C2 help the assessors understand the development of your innovation.
          }
        end

        year :innovation_developing_started_year, "Please provide the year when your innovation started to be developed." do
          sub_section :innovation_timeline_header
          classes "sub-question"
          sub_ref "C 2.1"
          required
          min 2000
          max 2020
        end

        date :innovation_was_launched_in_the_market, "Select the date when your innovation was launched in the market." do
          sub_section :innovation_timeline_header
          classes "sub-question date-DDMMYYYY"
          sub_ref "C 2.2"
          required
          context -> do
            %(
              <p>
                Your innovation isn't eligible for this award if it was launched in the market after #{AwardYear.start_trading_since(2)}.
              </p>
            )
          end

          date_max AwardYear.start_trading_since(2)
        end

        textarea :innovation_context, "Describe the market conditions that led to the creation of your innovation and how you identified a gap in the market." do
          sub_section :innovation_timeline_header
          classes "sub-question word-max-strict"
          sub_ref "C 2.3"
          required
          context %(
            <p>
              What was the need or opportunity that prompted you to initiate your innovation project? What research did you do? How did you decide it was an opportunity worth working on? Did the innovation happen by chance? Was it consumer-led, or did it arise out of research and development?
            </p>
          )
          rows 4
          words_max 400
        end

        textarea :innovation_desc_long, "Describe your innovation and why it is innovative." do
          sub_section :innovation_timeline_header
          classes "sub-question word-max-strict"
          sub_ref "C 2.4"
          required
          context %(
            <ol>
              <li>
                Describe what it is, how it works, what it does.
              </li>
              <li>
                Explain how your innovation differs from what came before and how it is an improvement.
              </li>
            </ol>
            <p>
              If your innovation is continuous, explain how it differs from and builds on what came before, even if its precursor is still on the market. Explain what adaptations you made to make it fit your business.
            </p>
            <p>
              If your innovation is disruptive, explain what is being replaced or substituted and how it is an improvement.
            </p>
            <p>
              Explain any aspects that you think are innovative and why you think they are innovative.
            </p>
            <p>
              If the innovation was conceived more than ten years ago, explain why it is still considered innovative.
            </p>
          )
          pdf_context %(
            <p>
              1. Describe what it is, how it works, what it does.
            </p>
            <p>
              2. Explain how your innovation differs from what came before and how it is an improvement.
            </p>
            <p>
              If your innovation is continuous, explain how it differs from and builds on what came before, even if its precursor is still on the market. Explain what adaptations you made to make it fit your business.
            </p>
            <p>
              If your innovation is disruptive, explain what is being replaced or substituted and how it is an improvement.
            </p>
            <p>
              Explain any aspects that you think are innovative and why you think they are innovative.
            </p>
            <p>
              If the innovation was conceived more than ten years ago, explain why it is still considered innovative.
            </p>
          )
          rows 5
          words_max 800
        end

        textarea :innovation_selection_details, "How did you select this innovation as the one to satisfy the gap in the market?" do
          sub_section :innovation_timeline_header
          classes "sub-question word-max-strict"
          sub_ref "C 2.5"
          required
          context %(
            <p>
              For example, explain if you conducted any consumer research, held focus groups, or did technical testing, for example, to see if it is faster, stronger, safer, or conducted cost or price benefit analyses. Summarise any quantitative and qualitative data that underpinned your decision making.
            </p>
          )
          rows 4
          words_max 350
        end

        textarea :innovation_overcomes_issues, "Describe any challenges you encountered in developing your innovation and how you overcame them." do
          sub_section :innovation_timeline_header
          classes "sub-question word-max-strict"
          sub_ref "C 2.6"
          required
          context %(
            <p>
              What challenges did you overcome, for example, technical, materials or capacity issues? How did you overcome the challenges? Did you create or identify solutions to challenges internally? Or did you seek external help, for example, from a university, business support organisation, or collaborative company? Did you identify technology or existing approaches that helped you overcome challenges? How did you establish which solution was the correct one?
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :innovation_strategies, "Explain the market opportunities and what strategies you used to penetrate the market." do
          sub_section :innovation_timeline_header
          classes "sub-question word-max-strict"
          sub_ref "C 2.7"
          required
          context %(
            <p>
              Who are your target customers? How did you communicate your innovation to them? Were they existing customers? Is this a new market sector? What did you have to do differently to market the innovation? What is the size of the market that you can potentially reach?
            </p>
          )
          rows 4
          words_max 350
        end

        textarea :innovation_competitors, "Who offers products, services or business models that compete with yours?" do
          sub_section :innovation_timeline_header
          classes "sub-question word-max-strict"
          sub_ref "C 2.8"
          required
          context %(
            <p>
              Define your competitors. Explain how your innovation differs from other offers in your field, including direct competitors and those that offer alternative solutions. We ask this to assess how outstanding your innovation is, compared to others in your field.
            </p>
          )
          rows 3
          words_max 250
        end

        textarea :innovation_protect_market_position_details, "How might you protect the market position you have created?" do
          sub_section :innovation_timeline_header
          classes "sub-question word-max-strict"
          sub_ref "C 2.9"
          required
          context %(
            <p>
              Explain if and why your innovation is hard to copy, for example, patents held, market position, trade secrets or design rights.
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :innovation_additional_comments, "Additional comments (optional)" do
          sub_section :innovation_timeline_header
          classes "sub-question word-max-strict"
          sub_ref "C 2.10"
          context %(
            <p>
              Use this box to explain if your innovation was launched by someone else or any other unusual circumstances surrounding your innovation.
            </p>
          )
          rows 2
          words_max 200
        end

        header :innovation_value_add_header, "Innovation value-add" do
          ref "C 3"
          linkable true
          context %{
            <p class="govuk-body">
              The questions in subsection C3 give you the opportunity to describe how your innovation adds value beyond the direct financial impact.
            </p>
            <p class="govuk-body">
              Please focus on providing descriptions and examples rather than financial data. Adding testimonials and quantified data to support your statements will strengthen your application.
            </p>
            <p class="govuk-body">
              You can add testimonials using quotation marks within the answer. Alternatively, if you have them in a letter or email format, consider joining them into one PDF and uploading it in section F - if you do so, please reference it in your answer.
            </p>
          }
          pdf_context_with_header_blocks [
            [:normal, %(
              The questions in subsection C3 give you the opportunity to describe how your innovation adds value beyond the direct financial impact.

              Please focus on providing descriptions and examples rather than financial data. Adding testimonials and quantified data to support your statements will strengthen your application.

              You can add testimonials using quotation marks within the answer. Alternatively, if you have them in a letter or email format, consider joining them into one PDF and uploading it in section F - if you do so, please reference it in your answer.
            )],
          ]
        end

        textarea :innovation_befits_details_business, "How has the innovation added value to your business?" do
          sub_section :innovation_value_add_header
          classes "sub-question word-max-strict"
          sub_ref "C 3.1"
          required
          context %(
            <p>
              When answering this question, please focus on softer, not directly financial benefits.
            </p>
            <p>
              For example, depending on what is applicable, you could mention that the innovation:
            </p>
            <ul>
              <li>Resulted in design, production, marketing, distribution and after-sales support improvements.</li>
              <li>Developed people's skills, knowledge, and expertise.</li>
              <li>Recruited new people into new roles or changed the structure of the business that will benefit the business in the future.</li>
              <li>Made your organisation more sustainable.</li>
              <li>Turned around business decline or increased the rate of growth.</li>
              <li>Increased efficiency, quality, reliability.</li>
              <li>Reduced costs, reduced downtime.</li>
            </ul>
            <p>
              Answer this question in narrative format rather than providing detailed financial figures - you will have an opportunity to add financials in section D of the form (Commercial Performance).
            </p>
          )
          pdf_context %(
            <p>
              When answering this question, please focus on softer, not directly financial benefits.
            </p>
            <p>
              For example, depending on what is applicable, you could mention that the innovation:
            </p>
            <p>
              \u2022 Resulted in design, production, marketing, distribution and after-sales support improvements.

              \u2022 Developed people's skills, knowledge, and expertise.

              \u2022 Recruited new people into new roles or changed the structure of the business that will benefit the business in the future.

              \u2022 Made your organisation more sustainable.

              \u2022 Turned around business decline or increased the rate of growth.

              \u2022 Increased efficiency, quality, reliability.

              \u2022 Reduced costs, reduced downtime.
            </p>
            <p>
              Answer this question in narrative format rather than providing detailed financial figures - you will have an opportunity to add financials in section D of the form (Commercial Performance).
            </p>
          )
          rows 4
          words_max 400
        end

        textarea :innovation_befits_details_customers, "Does the innovation benefit your customers, and if so, how?" do
          sub_section :innovation_value_add_header
          classes "sub-question word-max-strict"
          sub_ref "C 3.2"
          required
          context %(
            <p>
              For example:
            </p>
            <ul>
              <li>Increased efficiency</li>
              <li>Reduced costs</li>
              <li>Design, production, marketing, distribution or after-sales support improvements</li>
              <li>Better after-sales support</li>
              <li>Reduced downtime</li>
              <li>Increased reliability</li>
            </ul>
            <p>
              Please quantify if possible. For example, how much does it save your customers on average? You can use testimonials if you have them.
            </p>
          )
          pdf_context %(
            <p>
              For example:
            </p>
            <p>
              \u2022 Increased efficiency

              \u2022 Reduced costs

              \u2022 Design, production, marketing, distribution or after-sales support improvements

              \u2022 Better after-sales support

              \u2022 Reduced downtime

              \u2022 Increased reliability
            </p>
            <p>
              Please quantify if possible. For example, how much does it save your customers on average? You can use testimonials if you have them.
            </p>
          )
          rows 4
          words_max 400
        end

        textarea :beyond_your_immediate_customers, "Beyond your immediate customers, does the innovation benefit others, and if so, how and to whom?" do
          sub_section :innovation_value_add_header
          classes "sub-question word-max-strict"
          sub_ref "C 3.3"
          required
          context %(
            <p>
              Are there any wider benefits that your innovation delivers? For example, are there benefits to society,  specific groups of people, or the environment? Please provide evidence to support this if possible.
            </p>
          )
          rows 4
          words_max 400
        end
      end
    end
  end
end
