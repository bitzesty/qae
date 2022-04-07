# coding: utf-8
class AwardYears::V2023::QAEForms
  class << self
    def innovation_step2
      @innovation_step2 ||= proc do
        header :innovation_b_section_header, "" do
          context %(
            <h3 class='govuk-heading-m'>About section B</h3>
            <p class='govuk-body'>
              Questions in section B are structured to help tell the story of your innovation’s development, implementation, and impact - and why it deserves an award.
            </p>

            <h3 class='govuk-heading-s'>Word limits</h3>
            <p class='govuk-body'>
              What matters most is the quality of the information and insight you provide. The word limits for each question are just there to stop your application from becoming overlong and give an idea of the relative level of detail the assessors are looking for. Do not feel that you have to aim for the maximum number of words allowed.
            </p>

            <h3 class="govuk-heading-s">Technical language</h3>
            <p class="govuk-body">
              Please also avoid using technical language in this section of the application form. We need to understand what your innovation is without having any specific knowledge of your industry.
            </p>

            <h3 class="govuk-heading-s">Supporting information</h3>
            <p class="govuk-body">
              If you feel there is additional information that might support your application, you can attach documents in Section E. You should make sure that you reference any supporting documents, videos or websites in your answers below. Assessors have limited time to evaluate your application, so any additional documents should be kept short and relevant.
            </p>
          )

          pdf_context_with_header_blocks [
            [:bold, "About section B"],
            [:normal, %(
              Questions in section B are structured to help tell the story of your innovation’s development, implementation, and impact - and why it deserves an award.
            )],
            [:bold, "Word limits"],
            [:normal, %(
              What matters most is the quality of the information and insight you provide. The word limits for each question are just there to stop your application from becoming overlong and give an idea of the relative level of detail the assessors are looking for. Do not feel that you have to aim for the maximum number of words allowed.
            )],
            [:bold, "Technical language"],
            [:normal, %(
              Please also avoid using technical language in this section of the application form. We need to understand what your innovation is without having any specific knowledge of your industry.
            )],
            [:bold, "Supporting information"],
            [:normal, %(
              If you feel there is additional information that might support your application, you can attach documents in Section E. You should make sure that you reference any supporting documents, videos or websites in your answers below. Assessors have limited time to evaluate your application, so any additional documents should be kept short and relevant.
            )]
          ]
        end

        header :innovation_background_header, "Innovation background" do
          ref "B 1"
        end

        header :innovation_background_section_header, "" do
          section_info
          context %(
            <p class="govuk-body">
              The questions in subsection B1 help the assessors understand the context of your innovation.
            </p>
          )

          pdf_context %(
            <p>
              The questions in subsection B1 help the assessors understand the context of your innovation.
            </p>
          )
        end

        checkbox_seria :application_relate_to_header, "This entry relates to:" do
          classes "sub-question"
          sub_ref "B 1.1"
          required
          context %(
            <p>
              Select all that apply.
            </p>
          )
          check_options [
            ["product", "A product"],
            ["service", "A service"],
            ["business_model", "A business model or process"]
          ]
          application_type_question true
        end

        textarea :innovation_desc_short, "Briefly describe your innovative product, service, business model or process." do
          classes "sub-question word-max-strict"
          sub_ref "B 1.2"
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
          rows 1
          words_max 15
        end

        options :description_that_best_reflects_the_type_of_innovation, "Select the description that best reflects the type of your innovation." do
          classes "sub-question"
          sub_ref "B 1.3"
          required
          option "disruptive_innovation", %(
            Disruptive innovation: A new or creative-in-thought innovation that does not seem to have been done before. While having a financial return, it may not yet have secured substantial market impact and did not displace many other firms and products.
          )
          option "continuous_innovation", %(
            Continuous innovation: Innovation that adds new function or benefit to the existing product, service or business model.
          )
        end

        options :innovation_hold_existing_patent, "Do you hold the existing patent for this innovation?" do
          classes "sub-question"
          sub_ref "B 1.4"
          required
          yes_no
        end

        textarea :innovation_hold_existing_patent_details, "Provide a link to your published patent document. If you do not have a patent, please explain the reasons why not." do
          classes "sub-question"
          sub_ref "B 1.4.1"
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
          classes "sub-question"
          sub_ref "B 1.5"
          required
          yes_no
        end

        textarea :innovation_other_countries_it_was_developed, "Describe in what other countries and, if applicable, by what parties it was developed." do
          classes "sub-question"
          sub_ref "B 1.5.1"
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
          classes "sub-question"
          sub_ref "B 1.6"
          required
          context %(
            <p>
              If two or more organisations made a significant contribution to the product, service, business model or process, you should make a joint entry. Each organisation should submit separate, cross-referenced entry forms.
            </p>
          )
          yes_no
        end

        textarea :innovation_contributors, "Please enter their names." do
          classes "sub-question"
          sub_ref "B 1.6.1"
          conditional :innovation_joint_contributors, :yes
          rows 2
          words_max 100
        end

        options :innovation_any_contributors, "Did any external organisations or individuals contribute to your innovation?" do
          classes "sub-question"
          sub_ref "B 1.7"
          required
          yes_no
        end

        textarea :innovation_external_contributors, "Name any external organisations or individuals that contributed to your innovation, and explain their contributions." do
          classes "sub-question"
          sub_ref "B 1.7.1"
          required
          conditional :innovation_any_contributors, :yes
          rows 3
          words_max 200
        end

        options :innovation_contributors_aware, "Are they aware that you are applying for this award?" do
          classes "sub-question"
          sub_ref "B 1.7.2"
          required
          conditional :innovation_any_contributors, :yes
          option :yes, "Yes, they are all aware"
          option :no, "No, they are not all aware"
        end

        header :innovation_contributors_aware_header_no, "" do
          classes "application-notice help-notice"
          context %(
            <p class="govuk-body">
              We recommend that you notify all the contributors to your innovation of this entry.
            </p>
          )
          conditional :innovation_any_contributors, :yes
          conditional :innovation_contributors_aware, :no
        end

        textarea :innovation_contributors_why_organisations, "Explain why external organisations or individuals that contributed to your innovation are not all aware of this application." do
          classes "sub-question"
          sub_ref "B 1.7.3"
          required
          conditional :innovation_any_contributors, :yes
          conditional :innovation_contributors_aware, :no
          rows 3
          words_max 200
        end

        options :innovation_under_license, "Is your innovation under licence from another organisation?" do
          classes "sub-question"
          sub_ref "B 1.8"
          yes_no
        end

        textarea :innovation_license_terms, "Briefly describe the licensing arrangement." do
          classes "sub-question"
          sub_ref "B 1.8.1"
          required
          conditional :innovation_under_license, :yes
          rows 2
          words_max 100
        end

        options :innovations_grant_funding, "Have you received any grant funding or made use of any government support in relation to your innovation?" do
          classes "sub-question"
          sub_ref "B 1.9"
          required
          yes_no
          context %(
            <p>
              For example, this may include innovation loans or R&D tax credits.
            </p>
            <p>
              If you can evidence the use of government schemes or grant funding for this innovation, please include this. It will help the assessors build up a better picture of your innovation and the investment it has attracted.
            </p>
          )
        end

        textarea :innovation_grant_funding_sources, "Please give details of dates, sources and levels of funding." do
          classes "sub-question"
          sub_ref "B 1.9.1"
          required
          conditional :innovations_grant_funding, :yes
          rows 3
          words_max 250
        end


        header :innovation_timeline_header, "Innovation development" do
          ref "B 2"
        end

        header :innovation_timeline_section_header, "" do
          section_info
          context %(
            <p class="govuk-body">
              The questions in subsection B2 help the assessors understand the development of your innovation.
            </p>
          )

          pdf_context %(
            <p>
              The questions in subsection B2 help the assessors understand the development of your innovation.
            </p>
          )
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

        textarea :innovation_context, "Describe the market conditions that led to the creation of your innovation and how you identified a gap in the market." do
          classes "sub-question"
          sub_ref "B 2.3"
          required
          context %(
            <p>
              What was the need or opportunity that prompted you to commence your innovation project? What research did you do? How did you decide it was an opportunity worth working on? Was the innovation serendipitous? Was it consumer-led, or did it arise out of research and development?
            </p>
          )
          rows 4
          words_max 400
        end

        textarea :innovation_desc_long, "Describe your innovative product, service, or business model." do
          classes "sub-question"
          sub_ref "B 2.4"
          required
          context %(
            <p>
              Describe: What is it? How does it work? What does it do?
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :innovation_selection_details, "How did you select this innovation as the one to satisfy the gap in the market?" do
          classes "sub-question"
          sub_ref "B 2.5"
          required
          context %(
            <p>
              For example, explain if you conducted any consumer research, held focus groups, or did technical testing, for example, to see if it is faster, stronger, safer, or conducted cost or price benefit analyses. Summarise any quantitative and qualitative data that underpinned your decision making.
            </p>
          )
          rows 4
          words_max 350
        end

        textarea :innovation_improvement_details, "Why is your innovation innovative?" do
          classes "sub-question"
          sub_ref "B 2.6"
          required
          context %(
            <p>
              Explain how your innovation differs from what came before and how it is an improvement.
            </p>
            <p>
              If your innovation is continuous, explain how it differs from and builds on what came before, even if its precursor is still on the market. Explain what adaptations you made to make it fit your business. If your innovation is disruptive, explain what is being replaced or substituted and how it is an improvement.
            </p>
            <p>
            Explain any aspects that you think are innovative and why you think they are innovative.
            </p>
            <p>
              If the innovation was conceived more than ten years ago, explain why it is still considered innovative.
            </p>
          )
          rows 4
          words_max 400
        end

        textarea :innovation_overcomes_issues, "Describe any difficulties you encountered in developing your innovation and how you overcame them." do
          classes "sub-question"
          sub_ref "B 2.7"
          required
          context %(
            <p>
              What challenges did you overcome, for example, technical, materials or capacity? How did you overcome the challenges? Did you create or identify solutions to challenges internally? Or did you seek external help, for example, from a university, business support organisation, or collaborative company? Did you identify technology or existing approaches that helped you overcome challenges? How did you establish which solution was the correct one?
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :innovation_strategies, "Explain the market opportunities and what strategies you used to penetrate the market." do
          classes "sub-question"
          sub_ref "B 2.8"
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
          classes "sub-question"
          sub_ref "B 2.9"
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
          classes "sub-question"
          sub_ref "B 2.10"
          required
          context %(
            <p>
              Explain if and why your innovation is hard to copy, for example, patents held, market position, trade secrets or design rights.
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :innovation_additional_comments, "Additional comments. (optional)" do
          classes "sub-question"
          sub_ref "B 2.11"
          context %(
            <p>
              Use this box to explain if your innovation was launched by someone else or any other unusual circumstances surrounding your innovation.
            </p>
          )
          rows 2
          words_max 200
        end

        header :innovation_value_add_header, "Innovation value-add" do
          ref "B 3"
        end

        header :innovation_value_add_section_header, "" do
          section_info
          context %(
            <p class='govuk-body'>
              The questions in subsection B3 give you the opportunity to describe how your innovation adds value beyond any financial impact.
            </p>
            <p class='govuk-body'>
              You will be asked to include details of the financial benefits to your organisation in section C - Commercial Performance - of the form.
            </p>
            <p class='govuk-body'>
              Please focus on providing the strongest examples within the permitted word limits. Adding testimonials and quantified data to support your statements will strengthen your application.
            </p>
          )

          pdf_context %(
            <p>
              The questions in subsection B3 give you the opportunity to describe how your innovation adds value beyond any financial impact.
            </p>
            <p>
              You will be asked to include details of the financial benefits to your organisation in section C - Commercial Performance - of the form.
            </p>
            <p>
              Please focus on providing the strongest examples within the permitted word limits. Adding testimonials and quantified data to support your statements will strengthen your application.
            </p>
          )
        end

        textarea :innovation_befits_details_business, "How has the innovation added non-financial value to your business?" do
          classes "sub-question"
          sub_ref "B 3.1"
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
              What skills, knowledge, and expertise have you developed? Have you recruited people to new roles as a result of the innovation process? Have you changed the structure of your business to benefit in the future from the learnings you have made?
            </p>
            <p>
              Has the innovation made your organisation more sustainable? Has it turned around a decline? Or increased the rate of growth? Please answer this question in narrative format rather than detailed financial figures - you will have an opportunity to add these in section C - Commercial Performance -  of the form.
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
              What skills, knowledge, and expertise have you developed? Have you recruited people to new roles as a result of the innovation process? Have you changed the structure of your business to benefit in the future from the learnings you have made?
            </p>
            <p>
              Has the innovation made your organisation more sustainable? Has it turned around a decline? Or increased the rate of growth? Please answer this question in narrative format rather than detailed financial figures - you will have an opportunity to add these in section C - Commercial Performance -  of the form.
            </p>
          )
          rows 4
          words_max 400
        end

        textarea :innovation_befits_details_customers, "Does the innovation benefit your customers, and if so, how?" do
          classes "sub-question"
          sub_ref "B 3.2"
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
          classes "sub-question"
          sub_ref "B 3.3"
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
