class AwardYears::V2022::QaeForms
  class << self
    def innovation_step2
      @innovation_step2 ||= proc do
        header :innovation_b_section_header, "" do
          section_info
          context %(
            <h3 class='govuk-heading-m'>About this section</h3>
            <p class='govuk-body'>
              This section enables you to present the details of your innovation and to give us the evidence of its commercial impact on your business.
            </p>
            <p class='govuk-body'>
              Please avoid using technical language in this section of the application form. We need to understand what your innovation is without having any specific knowledge of your industry.
            </p>
            <h3 class="govuk-heading-m">Small organisations</h3>
            <p class="govuk-body">
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            </p>
            <h3 class="govuk-heading-m">COVID-19 impact</h3>
            <p class="govuk-body">
              We recognise that Covid-19 might have affected your growth plans and will take this into consideration during the assessment process.
            </p>
          )

          pdf_context_with_header_blocks [
            [:bold, "About this section"],
            [:normal, %(
              This section enables you to present the details of your innovation and to give us the evidence of its commercial impact on your business.
              Please avoid using technical language in this section of the application form. We need to understand what your innovation is without having any specific knowledge of your industry.
            )],
            [:bold, "Small organisations"],
            [:normal, %(
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            )],
            [:bold, "COVID-19 impact"],
            [:normal, %(
              We recognise that Covid-19 might have affected your growth plans and will take this into consideration during the assessment process.
            )],
          ]
        end

        checkbox_seria :application_relate_to_header, "This entry relates to:" do
          ref "B 1"
          required
          context %(
            <p>Select all that apply.</p>
          )
          check_options [
            ["product", "A product"],
            ["service", "A service"],
            ["business_model", "A business model"],
          ]
          application_type_question true
        end

        textarea :innovation_desc_short, "Briefly describe your innovative product, service or business model." do
          classes "sub-question word-max-strict"
          sub_ref "B 1.1"
          required
          context %(
            <p>
              This summary will be used in publicity material if your application is successful.
            </p>
            <p>
              For example:
            </p>
            <ul>
              <li>
                Fibre optic device to reproducibly modify the amplitude, direction or frequency of laser light.
              </li>
              <li>
                Innovative software testing tool to improve the efficiency and quality of software.
              </li>
              <li>
                Innovative person-centred, non-medical home care for the elderly.
              </li>
              <li>
                Leadership in the design and project management of biomethane gas-to-grid connections.
              </li>
            </ul>
          )
          pdf_context %(
            <p>
              This summary will be used in publicity material if your application is successful.
            </p>
            <p>
              For example:
            </p>
            <p>
              \u2022 Fibre optic device to reproducibly modify the amplitude, direction or frequency of laser light.

              \u2022 Innovative software testing tool to improve the efficiency and quality of software.

              \u2022 Innovative person-centred, non-medical home care for the elderly.

              \u2022 Leadership in the design and project management of biomethane gas-to-grid connections.
            </p>
          )
          rows 2
          words_max 15
        end

        textarea :innovation_desc_long, "Summarise your innovative product, service or business model." do
          classes "sub-question"
          sub_ref "B 1.2"
          required
          context %(
            <p>
              Describe the product, service or business model itself. Explain any aspect(s) that you think are innovative, and why you think they are innovative. Consider its uniqueness and the challenges you had to overcome. Explain if and why your innovation is hard to copy, for example, patents held, market position. Explain how it fits within the overall business, for example, is it your sole product. Also, please explain how the idea for the innovation came about.
            </p>
          )
          rows 5
          words_max 750
        end

        textarea :innovation_timeline_long, "Provide more details about your innovation’s timeline." do
          classes "sub-question"
          sub_ref "B 1.3"
          required
          context %(
            <p>
              Please include:
            </p>
            <ul>
              <li>
                Significant milestones during the development.
              </li>
              <li>
                Significant milestones after the launch.
              </li>
            </ul>
            <p>
              If the innovation was conceived more than ten years ago, explain why it would be considered still innovative now.
            </p>
          )
          pdf_context %(
            <p>
              Please include:
            </p>
            <p>
              \u2022 Significant milestones during the development.
              \u2022 Significant milestones after the launch.
            </p>
            <p>
              If the innovation was conceived more than ten years ago, explain why it would be considered still innovative now.
            </p>
          )
          rows 5
          words_max 200
        end

        header :innovation_timeline_header, "Your innovation timeline" do
          ref "B 2"
        end

        year :innovation_developing_started_year, "Please provide the year when your innovation started to be developed." do
          classes "sub-question"
          sub_ref "B 2.1"
          required
          min 2000
          max 2020
        end

        date :innovation_was_launched_in_the_market, "Select the date when your innovation was launched in the market." do
          classes "sub-question"
          sub_ref "B 2.2"
          required
          context -> do
            %(
              <p>
                Your innovation isn't eligible for this award if it was launched in the market after #{AwardYear.start_trading_since(2)} (if you are applying for the two-year award) or after #{AwardYear.start_trading_since(5)} (if you are applying for the five-year award).
              </p>
            )
          end

          date_max AwardYear.start_trading_since(2)
        end

        options :description_that_best_reflects_the_type_of_innovation, "Select the description that best reflects the type of your innovation" do
          ref "B 3"
          required
          option "disruptive_innovation", %(
            Disruptive innovation: A new or creative in thought innovation that does not seem to have been done before. While having a financial return, it may not yet have secured substantial market impact and did not displace many other firms and products
          )
          option "continuous_innovation", %(
            Continuous innovation: Innovation that adds new function or benefit to the existing product, service or business model
          )
          option "adoptive_innovation", %(
            Adoptive innovation: Innovation that has been done elsewhere but is used in a new way
          )
        end

        textarea :innovation_improvement_details, "Explain how your innovation differs from what was available before and how it is an improvement." do
          classes "sub-question"
          sub_ref "B 3.1"
          required
          context %(
            <p>
              If your innovation is adoptive or continuous, explain how it differs from and builds on what was available before (and may still be available on the market) and what adaptations you made to make it fit your business.
            </p>
            <p>
              If your innovation is disruptive, explain what is being replaced or substituted and how it is an improvement.
            </p>
          )
          rows 5
          words_max 400
        end

        options :innovation_hold_existing_patent, "Do you hold the existing patent for this innovation?" do
          ref "B 4"
          required
          yes_no
        end

        textarea :innovation_hold_existing_patent_details, "Provide details of the patent. If you do not have a patent, please explain the reasons why not." do
          classes "sub-question"
          sub_ref "B 4.1"
          required
          context %(
            <p>Include patent number.</p>
          )
          rows 5
          words_max 100
        end

        options :innovation_conceived_and_developed, "Was the whole of your innovation conceived and developed in the UK?" do
          ref "B 5"
          required
          yes_no
        end

        textarea :innovation_other_countries_it_was_developed, "Describe in what other countries (and by what parties) it was developed. Estimate what proportion of the innovation was developed there." do
          classes "sub-question"
          sub_ref "B 5.1"
          required
          conditional :innovation_conceived_and_developed, :no
          rows 5
          words_max 400
        end

        textarea :innovation_external_contributors, 'Name any external organisation(s)/individual(s) that contributed to your innovation, and explain their contribution(s) or enter "N/A".' do
          ref "B 6"
          required
          rows 5
          words_max 400
        end

        textarea :innovation_context, "Describe the market conditions that led to the creation of your innovation. Or otherwise, how you identified a gap in the market. " do
          ref "B 7"
          required
          rows 5
          words_max 500
        end

        textarea :innovation_overcomes_issues, "Describe the degree to which your innovation solves previous problems, and any difficulties you overcame in achieving these solutions." do
          ref "B 8"
          required
          rows 5
          words_max 750
        end

        textarea :innovation_befits_details_business, "How does the innovation benefit your business?" do
          ref "B 9"
          required
          context %(
            <p>
              For example, increased efficiency, reduction in costs, design/production/marketing/distribution improvements, better after-sales support, reduced downtime or increased reliability. You will have the opportunity to include more details of the financial benefits to your organisation in the Commercial Performance section of the form.
            </p>
          )
          rows 5
          words_max 400
        end

        textarea :innovation_befits_details_customers, "Does the innovation benefit your customers and, if so, how?" do
          ref "B 10"
          required
          context %(
            <p>
              For example, increased efficiency, reduction in costs, design/production/marketing/distribution improvements, better after-sales support, reduced downtime or increased reliability. Please quantify if possible. You can also include testimonials to support your claim.
            </p>
          )
          rows 5
          words_max 400
        end

        textarea :beyond_your_immediate_customers, "Beyond your immediate customers, does the innovation bring benefit to others, and if so how and to whom?" do
          ref "B 11"
          required
          rows 5
          words_max 400
        end

        textarea :innovation_competitors, "Who offers similar or different products, services or business models that compete with yours? Explain how your innovation differs from other offers in your field, including direct competitors and those that offer alternative solutions." do
          ref "B 12"
          required
          rows 5
          words_max 250
          context %(
            <p>We ask this so that we can assess how outstanding your innovation is, compared to others in your field.</p>
          )
        end

        textarea :innovation_strategies, "Explain what strategies you used to penetrate the market." do
          ref "B 13"
          required
          rows 5
          words_max 250
        end

        options :innovations_grant_funding, "Have you received any grant funding to support your innovation?" do
          ref "B 14"
          required
          yes_no
          context %(
            <p>
              If you have received grants for this innovation, it may strengthen your application. However, if you have not received any grants, it does not put you at a disadvantage.
            </p>
          )
        end

        textarea :innovation_grant_funding_sources, "Please give details of date(s), source(s) and level(s) of funding." do
          classes "sub-question"
          sub_ref "B 14.1"
          required
          conditional :innovations_grant_funding, :yes
          rows 5
          words_max 250
        end

        textarea :innovation_additional_comments, "Additional comments (optional)" do
          ref "B 15"
          rows 5
          words_max 200
          context %(
            <p>Use this box to explain if your innovation was launched by someone else, or any other unusual circumstances.</p>
          )
        end
      end
    end
  end
end
