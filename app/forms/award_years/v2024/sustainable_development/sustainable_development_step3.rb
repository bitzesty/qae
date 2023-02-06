# -*- coding: utf-8 -*-
class AwardYears::V2024::QAEForms
  class << self
    def development_step3
      @development_step3 ||= proc do
        header :development_c_section_header, "" do
          section_info
          context %(
            <h3 class='govuk-heading-m'>About section C</h3>
            <p class='govuk-body'>
              Read this section before planning the answers.
              Try not to repeat points, instead refer to the relevant answer you have previously provided to another question.
              <br />
              Avoid using technical jargon.
            </p>

            <h3 class='govuk-heading-m'>Small organisations</h3>
            <p class='govuk-body'>
              King's Awards for Enterprise is committed to acknowledging the efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all questions to the degree you can.
            </p>

            <h3 class='govuk-heading-m'>COVID-19 impact</h3>
            <p class='govuk-body'>
              We recognise that Covid-19 might have affected your growth plans and will take this into consideration during the assessment process.
            </p>

            <h3 class='govuk-heading-m'>United Nations Sustainable Development Goals (UN SDGs)</h3>
            <p class='govuk-body'>
              You may find it helpful to familiarise yourself with the United Nations 17 Sustainable Development Goals (UN SDGs). While they include impacts at a national level, you may want to reference the real positive impact your organisation contributes towards them.
            </p>
            <p class='govuk-body'>
              You do not need to show impact in each of these areas, only the ones that are most applicable to your sustainable development interventions.
            </p>

            <p class='govuk-body'>
              You can find more information about each goal on the United Nations (UN) website by clicking on the links below:
            </p>

            <p class='govuk-body'>
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal1.html">GOAL 1: No Poverty</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal2.html">GOAL 2: Zero Hunger</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal3.html">GOAL 3: Good Health and Well-being</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal4.html">GOAL 4: Quality Education</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal5.html">GOAL 5: Gender Equality</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal6.html">GOAL 6: Clean Water and Sanitation</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal7.html">GOAL 7: Affordable and Clean Energy</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal8.html">GOAL 8: Decent Work and Economic Growth</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal9.html">GOAL 9: Industry, Innovation and Infrastructure</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal10.html">GOAL 10: Reduced Inequality</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal11.html">GOAL 11: Sustainable Cities and Communities</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal12.html">GOAL 12: Responsible Consumption and Production</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal13.html">GOAL 13: Climate Action</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal14.html">GOAL 14: Life Below Water</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal15.html">GOAL 15: Life on Land</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal16.html">GOAL 16: Peace and Justice Strong Institutions</a><br />
              <a class="govuk-link social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal17.html">GOAL 17: Partnerships to achieve the Goal</a>
            </p>
          )

          pdf_context_with_header_blocks [
            [:bold, "About section C"],
            [:normal, %(
              Read this section before planning the answers.
              Try not to repeat points, instead refer to the relevant answer you have previously provided to another question.
              Avoid using technical jargon.
            )],
            [:bold, "Small organisations"],
            [:normal, %(
              King's Awards for Enterprise is committed to acknowledging the efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all questions to the degree you can.
            )],
            [:bold, "COVID-19 impact"],
            [:normal, %(
              We recognise that Covid-19 might have affected your growth plans and will take this into consideration during the assessment process.
            )],
            [:bold, "United Nations Sustainable Development Goals (UN SDGs)"],
            [:normal, %(
              You may find it helpful to familiarise yourself with the United Nations 17 Sustainable Development Goals (UN SDGs). While they include impacts at a national level, you may want to reference the real positive impact your organisation contributes towards them.

              You do not need to show impact in each of these areas, only the ones that are most applicable to your sustainable development interventions.

              \u2022 GOAL 1: No Poverty
              https://www.un.org/development/desa/disabilities/envision2030-goal1.html

              \u2022 GOAL 2: Zero Hunger
              https://www.un.org/development/desa/disabilities/envision2030-goal2.html

              \u2022 GOAL 3: Good Health and Well-being
              https://www.un.org/development/desa/disabilities/envision2030-goal3.html

              \u2022 GOAL 4: Quality Education
              https://www.un.org/development/desa/disabilities/envision2030-goal4.html

              \u2022 GOAL 5: Gender Equality
              https://www.un.org/development/desa/disabilities/envision2030-goal5.html

              \u2022 GOAL 6: Clean Water and Sanitation
              https://www.un.org/development/desa/disabilities/envision2030-goal6.html

              \u2022 GOAL 7: Affordable and Clean Energy
              https://www.un.org/development/desa/disabilities/envision2030-goal7.html

              \u2022 GOAL 8: Decent Work and Economic Growth
              https://www.un.org/development/desa/disabilities/envision2030-goal8.html

              \u2022 GOAL 9: Industry, Innovation and Infrastructure
              https://www.un.org/development/desa/disabilities/envision2030-goal9.html

              \u2022 GOAL 10: Reduced Inequality
              https://www.un.org/development/desa/disabilities/envision2030-goal10.html

              \u2022 GOAL 11: Sustainable Cities and Communities
              https://www.un.org/development/desa/disabilities/envision2030-goal11.html

              \u2022 GOAL 12: Responsible Consumption and Production
              https://www.un.org/development/desa/disabilities/envision2030-goal12.html

              \u2022 GOAL 13: Climate Action
              https://www.un.org/development/desa/disabilities/envision2030-goal13.html

              \u2022 GOAL 14: Life Below Water
              https://www.un.org/development/desa/disabilities/envision2030-goal14.html

              \u2022 GOAL 15: Life on Land
              https://www.un.org/development/desa/disabilities/envision2030-goal15.html

              \u2022 GOAL 16: Peace and Justice Strong Institutions
              https://www.un.org/development/desa/disabilities/envision2030-goal16.html

              \u2022 GOAL 17: Partnerships to achieve the Goal
              https://www.un.org/development/desa/disabilities/envision2030-goal17.html
            )]
          ]
        end

        header :sustainable_development_interventions_summary_header, "Summary of your Sustainable Development Interventions" do
          ref "C 1"
        end

        textarea :one_line_description_of_interventions, "Provide a one-line description of your sustainable development interventions." do
          classes "sub-question word-max-strict"
          ref "C 1.1"
          required
          context %(
            <p>If your application is successful, this description will appear in the London Gazette.</p>
            <p>Some good examples from previously shortlisted organisations:</p>
            <ul>
              <li>Supplying repurposed redundant oilfield tubulars as steel foundation piling to reduce CO2 emissions.</li>
              <li>Manufacturer of environmentally friendly cleaning products since 2007. Loved by professionals, approved by the planet.</li>
              <li>Our IT Disposal and Gifting service transforms waste for the benefit of people and the planet.</li>
            </ul>
          )
          pdf_context %{
            <p>If your application is successful, this description will appear in the London Gazette.</p>
            <p>Some good examples from previously shortlisted organisations:</p>
            <p>
              \u2022 Supplying repurposed redundant oilfield tubulars as steel foundation piling to reduce CO2 emissions.
              \u2022 Manufacturer of environmentally friendly cleaning products since 2007. Loved by professionals, approved by the planet.
              \u2022 Our IT Disposal and Gifting service transforms waste for the benefit of people and the planet.
            </p>
          }
          rows 2
          words_max 15
        end

        textarea :briefly_describe_your_interventions, "Briefly describe your sustainable development interventions." do
          classes "sub-question word-max-strict"
          ref "C 1.2"
          required
          context %(
            <p>This is to provide more context for the questions that follow. You will have the opportunity to elaborate on it in C5 questions.</p>
          )
          rows 2
          words_max 200
        end

        header :sustainable_development_core_business_header, "Core business and your approach to sustainability" do
          ref "C 2"
          context %{
            <p class='govuk-hint'>In questions C2.1 to C2.7 describe your core business and what factors or issues motivated your organisation to develop sustainable ways of doing business.</p>
          }
        end

        textarea :briefly_describe_your_core_business, "A brief summary of your organisation." do
          classes "word-max-strict sub-question"
          ref "C 2.1"
          required
          rows 2
          words_max 200
        end

        textarea :describe_previous_situation_before_sustainability, "What was the situation before your organisation adopted a sustainability purpose, objectives and intervention?" do
          classes "word-max-strict sub-question"
          ref "C 2.2"
          required
          rows 2
          words_max 200
        end

        textarea :why_these_particular_interventions, "Why did you choose these particular interventions, and how do they align with the core aims and values of your organisation?" do
          classes "word-max-strict sub-question"
          ref "C 2.3"
          required
          rows 2
          words_max 200
        end

        textarea :how_have_you_embedded_sustainability_objectives, "How have you embedded sustainability objectives or purpose in your organisation?" do
          classes "word-max-strict sub-question"
          ref "C 2.4"
          required
          rows 2
          words_max 200
        end

        textarea :explain_how_the_business_operates_sustainably, "If your application is focussed on particular sustainable development interventions, explain how your whole business also operates sustainably, especially in terms of climate change." do
          classes "word-max-strict sub-question"
          ref "C 2.5"
          required
          context %{
            <p>As a minimum, we expect all winning organisations to have good practices around climate change. Therefore, if your sustainable development interventions are not climate focused, describe:</p>
            <p>a) your strategy and approach related to climate change.</p>
            <p>b) your climate change related targets. Be clear whether your targets are for carbon neutrality or, if you go further, aiming for “net zero”.</p>
            <p>c) how you have measured your emissions.</p>
            <p>Please note, if your application is focused on climate change, do not repeat climate change related information in your answer to C2.5, just state that it's covered in other answers.</p>
            <p>However, you may highlight other areas that show your organisation operates sustainability that are not covered in your other answers such as being part of the circular economy, or reductions in use of plastics.</p>
          }
          rows 2
          words_max 200
        end

        textarea :how_sustainability_interventions_benefit_business_strategy, "How sustainability interventions benefit the overall business strategy?" do
          classes "word-max-strict sub-question"
          ref "C 2.6"
          required
          rows 2
          words_max 200
        end

        textarea :explain_your_strategy_in_developing_sustainably, "Explain your strategy in developing sustainably for the future." do
          classes "word-max-strict sub-question"
          ref "C 2.7"
          required
          context %{
            <p>For example, how are you changing your business to respond to future sustainability challenges in your business or sector?</p>
          }
          rows 2
          words_max 200
        end

        header :leadership_and_management, "Leadership and management" do
          ref "C 3"
          context %{
            <p class="govuk-hint">In questions C3.1 to C3.8 describe the driving force of your organisation's sustainability.</p>
          }
        end

        textarea :describe_the_driving_force_of_your_organisation, "Leadership and management" do
          classes "word-max-strict sub-question"
          ref "C 3.1"
          required
          rows 2
          words_max 200
        end

        textarea :who_is_responsible_for_day_to_day_management, "Who is responsible for the day-to-day management, and the main areas of sustainability, in your organisation?" do
          classes "word-max-strict sub-question"
          ref "C 3.2"
          required
          context %{
            <p>You may include flow charts to make it easier for assessors to understand how your programme is managed in section E of this form.</p>
          }
          rows 2
          words_max 200
        end

        textarea :describe_the_senior_decision_makers_commitment_to_sustainability, "What is the senior decision makers' commitment to the future sustainable growth of the organisation?" do
          classes "word-max-strict sub-question"
          ref "C 3.3"
          required
          rows 2
          words_max 200
        end

        textarea :how_does_your_organisation_inspire_others, "How does your organisation inspire other organisations to be more sustainable?" do
          classes "word-max-strict sub-question"
          ref "C 3.4"
          required
          context %{
            <p>For example, businesses in your supply chain, stakeholders, customers or local communities.</p>
          }
          rows 4
          words_max 400
        end

        textarea :how_do_you_collaborate_with_partners, "How do you collaborate with partners and others to develop best practice?" do
          classes "word-max-strict sub-question"
          ref "C 3.5"
          required
          rows 2
          words_max 200
        end

        textarea :describe_your_organisation_diversity, "Describe your organisation's diversity and inclusion strategy, including how your organisation attracts, recruits, promotes and retains a diverse workforce." do
          classes "word-max-strict sub-question"
          ref "C 3.6"
          required
          context %{
            <p>Explain your policies and provide evidence that these are effective.</p>
          }
          rows 5
          words_max 500
        end

        textarea :describe_how_employee_relations_improved_their_motivation, "How has your employee relations improved their motivation, well-being and satisfaction?" do
          classes "word-max-strict sub-question"
          ref "C 3.7"
          required
          rows 2
          words_max 200
        end

        header :culture_and_values, "Culture and values regarding sustainability" do
          ref "C 4"
          context %{
            <p class="govuk-hint">In questions C4.1 to C4.4 describe how your organisation's culture fosters and supports sustainability.</p>
          }
        end

        textarea :culture_and_values_regarding_sustainability, "How is sustainability embedded in your organisation's culture and values?" do
          classes "word-max-strict sub-question"
          ref "C 4.1"
          required
          rows 2
          words_max 200
        end

        textarea :how_do_you_increase_positive_perception_of_sustainability, "How do you increase positive perceptions of your organisation's sustainability among customers, stakeholders, or the media?" do
          classes "word-max-strict sub-question"
          ref "C 4.2"
          required
          rows 2
          words_max 200
        end

        textarea :how_do_you_communicate_the_impact_of_sustainability, "How do you communicate the impact of your sustainability interventions to employees, stakeholders, your supply chain, communities or similar?" do
          classes "word-max-strict sub-question"
          ref "C 4.3"
          required
          context %{
            <p>Please include links to relevant pages on your company's website, social media or alternative channels where you demonstrate your leadership in Sustainable Development.</p>
            <p>If applicable, include in your answer or attach in section E of this form: newsletters, quotes or similar material to bring to life how you communicate the value you place on sustainability.</p>
          }
          rows 2
          words_max 200
        end

        textarea :what_are_your_long_term_plans_for_sustainability, "What are your long-term plans for ensuring your organisation provides the leadership, innovation or intervention to enable greater sustainable development?" do
          classes "word-max-strict sub-question"
          ref "C 4.4"
          required
          rows 2
          words_max 200
        end

        header :sustainable_development_interventions_header, "Your sustainable development interventions" do
          ref "C 5"
          context %{
            <p class="govuk-hint">In questions C5.1 to C5.4 describe your interventions, using the UN SDGs to structure your answer where relevant. You need to summarise your actions or interventions to sustainable development and demonstrate a sustainable strategy across the business.</p>
          }
        end

        textarea :describe_your_interventions_using_un, "Describe your interventions, using the UN Sustainable Development (SD) goals to structure your answer where relevant." do
          required
          classes "sub-question"
          sub_ref "C 5.2"
          context %{
            <p>
              Where relevant, please include:
            </p>
            <p>
              a) The aims of the actions or interventions, for example, to regenerate, to restore, to reduce emissions.
            </p>
            <p>
              b) Which SD goals are your efforts targeted towards? Please note, you do not need to address each UN SD goal, only the ones that are most applicable to your sustainable development actions or interventions.
            </p>
            <p>
              c) The proportion of these interventions compared to your whole organisation’s size.
            </p>
            <p>
              d) Provide evidence of what makes your actions or interventions exemplary. For example, it may be exemplary as a result of:
            </p>
            <ul>
              <li>
                An overall strategy where complementary programmes are linked to form a powerful series of engagements to inform, inspire, guide, recruit or develop people.
              </li>
              <li>
                Developing unique or innovative ways, products or services to be sustainable.
              </li>
              <li>
                Forming effective partnerships with other organisations, for example, businesses in your supply chain, charities or schools.
              </li>
              <li>
                Leading the way in your company, sector or market by doing something that has never been done before.
              </li>
            </ul>
          }

          pdf_context %{
            <p>
              Where relevant, please include:
            </p>
            <p>
              a) The aims of the actions or interventions, for example, to regenerate, to restore, to reduce emissions.
            </p>
            <p>
              b) Which SD goals are your efforts targeted towards? Please note, you do not need to address each UN SD goal, only the ones that are most applicable to your sustainable development actions or interventions.
            </p>
            <p>
              c) The proportion of these interventions compared to your whole organisation’s size.
            </p>
            <p>
              d) Provide evidence of what makes your actions or interventions exemplary. For example, it may be exemplary as a result of:
            </p>
            <p>
              \u2022 An overall strategy where complementary programmes are linked to form a powerful series of engagements to inform, inspire, guide, recruit or develop people.

              \u2022 Developing unique or innovative ways, products or services to be sustainable.

              \u2022 Forming effective partnerships with other organisations, for example, businesses in your supply chain, charities or schools.

              \u2022 Leading the way in your company, sector or market by doing something that has never been done before.
            </p>
          }

          rows 10
          words_max 1000
        end

        textarea :governance, "Governance" do
          ref "C 6"
          required
          context %(
            <p>
              If you are a large organisation, you may wish to describe:
            </p>
            <ul>
              <li>How you uphold ethical standards within your core business.</li>
              <li>How you ensure diversity of representation, including at very senior levels.</li>
              <li>How you engage stakeholders in your governance.</li>
              <li>Your company's policies on pay and shareholder rights.</li>
              <li>Any other notable policies or practices, for example, relating to transparency, compliance, accounting, tax, risk, controls or audit.</li>
            </ul>
            <p>
              If you are a small organisation, some of the previous points may be less relevant, therefore you may wish to describe:
            </p>
            <ul>
              <li>Involvement of Non-Executive Directors on the board.</li>
              <li>How the board ensures that ethical standards are considered and adhered to.</li>
              <li>How the board ensures that statutory obligations are met.</li>
            </ul>
          )
          pdf_context %(
            <p>
              You may wish to describe:
            </p>
            <p>
              \u2022 How you uphold ethical standards within your core business.

              \u2022 How you ensure diversity of representation, including at very senior levels.

              \u2022 How you engage stakeholders in your governance.

              \u2022 Your company's policies on pay and shareholder rights.

              \u2022 Any other notable policies or practices, for example, relating to transparency, compliance, accounting, tax, risk, controls or audit.
            </p>
            <p>
              If you are a small organisation, some of the previous points may be less relevant, therefore you may wish to describe:
            </p>
            <p>
              \u2022 Involvement of Non-Executive Directors on the board.

              \u2022 How the board ensures that ethical standards are considered and adhered to.

              \u2022 How the board ensures that statutory obligations are met.
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :impact_of_your_sustainable_development, "Impact of your sustainable development" do
          classes "word-max-strict"
          ref "C 6"
          required
          question_sub_title %{
            Please describe the impact. Focus on what impact your activities have achieved to date but include the longer-term outcomes as well.
          }
          context %{
            <p>
              Wherever possible, use a balance of quantitative (for example, numbers and figures) and qualitative (for example, comments, feedback from people, main stakeholders) evidence to support your application.
            </p>
            <p>
              Where possible, please include:
            </p>
            <p>
              a) How you measure the success of your sustainability intervention? For example, are key performance indicators (KPIs) or targets used? If so, how are they set and monitored? Are the KPIs or targets being met, and what happens if they are not?
            </p>
            <p>
              b) State what qualitative measures were used to evaluate the success of your sustainable business objectives to your organisation, customers, employees or others in meeting objectives for performance.
            </p>
            <p>
              c) The impact of your sustainable objectives. For example, impact on your organisation, employees, customers, stakeholders, supply chain, communities, regions or others, such as overseas clients or markets.
            </p>
            <p>
              d) How the impact compares to the sector. Please state what sector research or other evidence you have used to benchmark this. Include a web link to any research, if available.
            </p>
            <p>
              e) What longer-term outcomes do you expect as a result of your sustainable development efforts?
            </p>
            <p>
              f) State which recognised standards and accreditations your company has achieved, for example, ISO 14000, B-Corp accreditation.
            </p>
          }
          rows 10
          words_max 1000
        end

        header :additional_materials_notes, "" do
          classes "application-notice help-notice"
          context %(
            <p class="govuk-body">
              If there is additional material you feel would help us to assess your entry, you can add up to three files of website addresses in section D of this form. However, please include any vital information in your answers in the questions above as we cannot guarantee the additional material will be reviewed in full.
            </p>
          )
        end
      end
    end
  end
end
