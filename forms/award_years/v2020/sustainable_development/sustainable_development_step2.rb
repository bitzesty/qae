# -*- coding: utf-8 -*-
class AwardYears::V2020::QaeForms
  class << self
    def development_step2
      @development_step2 ||= proc do
        header :development_b_section_header, "" do
          context %(
            <h3>About this section</h3>
            <p>
              Read this section before planning the answers.
              Try not to repeat points, instead refer to the relevant answer you have previously provided to another question.
              <br />
              Avoid using technical jargon.
            </p>

            <h3>Small organisations</h3>
            <p>
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            </p>

            <h3>Sustainable Development Goals (SDGs)</h3>
            <p>
              You may find it helpful to familiarise yourself with the United Nations (UN) 17 Sustainable Development Goals (SDGs). While they include impacts at a national level, you may want to reference the real positive impact your organisation contributes towards them.
            </p>
            <p>
              You do not need to show impact in each of these areas, only the ones that are most applicable to your sustainable development actions or interventions.
            </p>

            <p>
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal1.html">GOAL 1: No Poverty</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal2.html">GOAL 2: Zero Hunger</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal3.html">GOAL 3: Good Health and Well-being</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal4.html">GOAL 4: Quality Education</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal5.html">GOAL 5: Gender Equality</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal6.html">GOAL 6: Clean Water and Sanitation</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal7.html">GOAL 7: Affordable and Clean Energy</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal8.html">GOAL 8: Decent Work and Economic Growth</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal9.html">GOAL 9: Industry, Innovation and Infrastructure</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal10.html">GOAL 10: Reduced Inequality</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal11.html">GOAL 11: Sustainable Cities and Communities</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal12.html">GOAL 12: Responsible Consumption and Production</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal13.html">GOAL 13: Climate Action</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal14.html">GOAL 14: Life Below Water</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal15.html">GOAL 15: Life on Land</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal16.html">GOAL 16: Peace and Justice Strong Institutions</a><br />
              <a class="social-mobility-form-goal-link" target="_blank" href="https://www.un.org/development/desa/disabilities/envision2030-goal17.html">GOAL 17: Partnerships to achieve the Goal</a>
            </p>
          )

          pdf_context_with_header_blocks [
            [:bold, "About this section"],
            [:normal, %(
              Read this section before planning the answers.
              Try not to repeat points, instead refer to the relevant answer you have previously provided to another question.
              Avoid using technical jargon.
            )],
            [:bold, "Small organisations"],
            [:normal, %(
              Queen’s Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider what is reasonable performance given the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer them to a degree you can.
            )],
            [:bold, "Sustainable Development Goals (SDGs)"],
            [:normal, %(
              You may find it helpful to familiarise yourself with the United Nations (UN) 17 Sustainable Development Goals (SDGs). While they include impacts at a national level, you may want to reference the real positive impact your organisation contributes towards them.

              You do not need to show impact in each of these areas, only the ones that are most applicable to your sustainable development actions or interventions.

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

        header :sustainable_development_interventions_header, "Your sustainable development interventions" do
          ref "B 1"
          context %(
            <p>
              In questions B1.1 and B1.2 you need to summarise your actions or interventions to sustainable development. This is to help us understand the size and scale of your actions or interventions. This summary might be used in publicity material if your application is successful.
            </p>
          )
        end

        textarea :describe_your_interventions_using_un, "Describe your interventions, using the UN Sustainable Development (SD) goals to structure your answer where relevant." do
          required
          classes "sub-question"
          sub_ref "B 1.1"
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

        textarea :one_line_description_of_interventions, "Provide a one-line description of your sustainable development interventions." do
          classes "sub-question word-max-strict"
          ref "B 1.2"
          required
          context %(
            <p>
              If your application is successful, this description will appear in the London Gazette.
            </p>
          )
          rows 2
          words_max 15
        end

        textarea :briefly_describe_your_core_business, "Your core business" do
          classes "word-max-strict"
          ref "B 2"
          required
          question_sub_title %{
            Briefly describe your core business and what factors or issues motivated your organisation to develop sustainable ways of doing business.
          }
          context %{
            <p>
              Please include:
            </p>
            <p>
              a) A brief summary of your organisation.
            </p>
            <p>
              b) What was the situation before your organisation adopted a sustainability purpose, objective, intervention or action?
            </p>
            <p>
              c) Why did you choose these particular actions or interventions, and how do they align with the core aims and values of your organisation?
            </p>
            <p>
              d) How have you embedded sustainability objectives or purpose in your organisation?
            </p>
          }
          rows 5
          words_max 600
        end

        textarea :impact_of_your_sustainable_development, "Impact of your sustainable development" do
          classes "word-max-strict"
          ref "B 3"
          required
          context %{
            <p>
              Please describe the impact. Focus on what impact your activities have achieved to date but include the longer-term outcomes as well.
            </p>
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
              d) What longer-term outcomes do you expect as a result of your sustainable development efforts?
            </p>
          }
          rows 10
          words_max 1000
        end

        textarea :describe_the_driving_force_of_your_organisation, "Leadership and management" do
          classes "word-max-strict"
          ref "B 4"
          required
          question_sub_title %{
            Please describe the driving force of your organisation’s sustainability.
          }
          context %{
            <p>
              a) Who is ultimately responsible for the organisation’s sustainability interventions and their success?
            </p>
            <p>
              b) Who is responsible for the day-to-day management, and the main areas of sustainability, in your organisation?<br />
              You may include flow charts to make it easier for assessors to understand how your programme is managed in section D of this form.
            </p>
            <p>
              c) What is the senior decision makers’ commitment to the future sustainable growth of the organisation?
            </p>
            <p>
              d) If possible, provide details on how the scale of this programme compares with similar organisations in your sector or industry.
            </p>
            <p>
              e) How does your organisation inspire other organisations to be more sustainable? For example, businesses in your supply chain, stakeholders, customers or local communities.
            </p>
            <p>
              f) If relevant, provide details on how you collaborate with partners and others to develop best practice.
            </p>
            <p>
              g) Describe your organisation’s strategy to attract, recruit, promote and retain a diverse workforce.
            </p>
            <p>
              h) How has your employee relations improved motivation, well-being and satisfaction?
            </p>
          }
          rows 10
          words_max 1000
        end

        textarea :culture_and_values_regarding_sustainability, "Culture and values regarding sustainability" do
          classes "word-max-strict"
          ref "B 5"
          required
          question_sub_title %{
            Describe how your organisation’s culture fosters and supports sustainability.
          }
          context %{
            <p>
              Please include:
            </p>
            <p>
              a) How is sustainability embedded in your organisation’s culture and values?
            </p>
            <p>
              b) How sustainability interventions benefit the overall business strategy?
            </p>
            <p>
              c) How do you increase positive perceptions of your organisation’s sustainability among customers, stakeholders, or the media?
            </p>
            <p>
              d) What mechanisms are in place to communicate the impact of your sustainability interventions to employees, stakeholders, your supply chain, communities or similar?<br />
              If applicable, include in your answer or attach in section D of this form: newsletters, quotes or similar material to bring to life how you communicate the value you place on sustainability. Please note, where applicable, your company website or social media channels will be researched for evidence of your sustainability values, policies or promotion.
            </p>
            <p>
              e) What are your long-term plans for ensuring your organisation provides the leadership, innovation or intervention to enable greater sustainable development?
            </p>
          }
          rows 10
          words_max 1000
        end

        header :additional_materials_notes, "" do
          classes "application-notice help-notice"
          context %(
            <p>
              If there is additional material you feel would help us to assess your entry, you can add up to three files of website addresses in section D of this form. However, please include any vital information in your answers in the questions above as we cannot guarantee the additional material will be reviewed in full.
            </p>
          )
        end
      end
    end
  end
end
