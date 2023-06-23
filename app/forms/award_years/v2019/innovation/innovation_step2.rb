class AwardYears::V2019::QaeForms
  class << self
    def innovation_step2
      @innovation_step2 ||= proc do
        header :innovation_b_section_header, "" do
          context %(
            <p>
              This section enables you to present the detail of your innovation and to give us the evidence of its commercial impact on your business that will allow us to assess your application.
            </p>
            <p>
              Please avoid using technical language in this section of the application form. We need to understand what your innovation is without having any specific knowledge of your industry.
            </p>
          )
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
            ["business_model", "A business model"]
          ]
          application_type_question true
        end

        textarea :innovation_desc_short, "Briefly describe your innovative product, service or business model." do
          ref "B 1.1"
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
          classes "sub-question word-max-strict"
          words_max 15
        end

        textarea :innovation_desc_long, "Summarise your innovative product, service or business model." do
          classes "sub-question"
          sub_ref "B 1.2"
          required
          context %(
            <p>
              Describe the product, service or business model itself. Explain any aspect(s) that you think are innovative, and why you think they are innovative. Consider its uniqueness and the challenges you had to overcome. Explain if and why your innovation is hard to copy, for example, patents held, market position. Also explain how it fits within the overall business, for example, is it your sole product.
            </p>
          )
          rows 5
          words_max 750
        end

        options :innovation_hold_existing_patent, "Do you hold the existing patent for this innovation?" do
          ref "B 2"
          required
          yes_no
        end

        textarea :innovation_hold_existing_patent_details, "Provide details of the patent. If you do not have a patent, please explain the reasons why not." do
          classes "sub-question"
          sub_ref "B 2.1"
          required
          context %(
            <p>Include patent number.</p>
          )
          rows 5
          words_max 100
        end


        options :innovation_conceived_and_developed, "Was the whole of your innovation conceived and developed in the UK?" do
          ref "B 3"
          required
          yes_no
        end

        textarea :innovation_other_countries_it_was_developed, "Describe in what other countries (and by what parties) it was developed. Estimate what proportion of the innovation was developed there." do
          classes "sub-question"
          sub_ref "B 3.1"
          required
          conditional :innovation_conceived_and_developed, :no
          rows 5
          words_max 400
        end

        textarea :innovation_external_contributors, 'Name any external organisation(s)/individual(s) that contributed to your innovation, and explain their contribution(s) or enter "N/A".' do
          ref "B 4"
          required
          rows 5
          words_max 400
        end

        textarea :innovation_context, "Describe the market conditions that led to the creation of your innovation. Or otherwise, how you identified a gap in the market. " do
          ref "B 5"
          required
          rows 5
          words_max 500
        end

        textarea :innovation_overcomes_issues, "Describe the degree to which your innovation solves previous problems, and any difficulties you overcame in achieving these solutions." do
          ref "B 6"
          required
          rows 5
          words_max 750
        end

        textarea :innovation_befits_details_business, "How does the innovation benefit your business?" do
          ref "B 7"
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
          ref "B 8"
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
          ref "B 9"
          required
          rows 5
          words_max 400
        end

        textarea :innovation_competitors, "Who offers similar or different products, services or business models that compete with yours? Explain how your innovation differs from other offers in your field, including direct competitors and those that offer alternative solutions." do
          ref "B 10"
          required
          rows 5
          words_max 250
          context %(
            <p>We ask this so that we can assess how outstanding your innovation is, compared to others in your field.</p>
          )
        end

        options :innovations_grant_funding, "Have you received any grant funding to support your innovation?" do
          ref "B 11"
          required
          yes_no
          context %(
            <p>
              We ask this to help us carry out due diligence if your application is shortlisted.
            </p>
          )
        end

        textarea :innovation_grant_funding_sources, "Please give details of date(s), source(s) and level(s) of funding." do
          classes "sub-question"
          sub_ref "B 11.1"
          required
          conditional :innovations_grant_funding, :yes
          rows 5
          words_max 250
        end

        date :innovation_was_launched_in_the_market, "Select the date when your innovation was launched in the market." do
          required
          ref "B 12"
          context -> do
            %(
              <p>
                Your innovation isn't eligible for this award if it was launched in the market after #{AwardYear.start_trading_since(2)} (or after #{AwardYear.start_trading_since(5)} if you are applying for the five-year award).
              </p>
            )
          end

          date_max AwardYear.start_trading_since(2)
        end

        textarea :innovation_additional_comments, "Additional comments (optional)" do
          ref "B 13"
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
