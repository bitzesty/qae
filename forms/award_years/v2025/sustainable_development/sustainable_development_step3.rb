class AwardYears::V2025::QaeForms
  class << self
    def development_step3
      @development_step3 ||= proc do
        about_section :development_c_section_header, "" do
          section "your_sustainable_development"
        end

        header :sustainable_development_interventions_summary_header, "Summary of your sustainable development interventions" do
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
          pdf_context %(
            <p>If your application is successful, this description will appear in the London Gazette.</p>
            <p>Some good examples from previously shortlisted organisations:</p>
            <p>
              \u2022 Supplying repurposed redundant oilfield tubulars as steel foundation piling to reduce CO2 emissions.
              \u2022 Manufacturer of environmentally friendly cleaning products since 2007. Loved by professionals, approved by the planet.
              \u2022 Our IT Disposal and Gifting service transforms waste for the benefit of people and the planet.
            </p>
          )
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
          context %(
            <p class='govuk-hint'>
              In questions C2.1 to C2.7, describe your core business and what factors or issues motivated your organisation to develop sustainable ways of doing business.
            </p>
          )
        end

        textarea :briefly_describe_your_core_business, "A brief summary of your organisation." do
          classes "word-max-strict sub-question"
          ref "C 2.1"
          context %(
            <p>
              Please describe what your business does.
            </p>
          )
          required
          rows 2
          words_max 200
        end

        textarea :describe_previous_situation_before_sustainability,
                 "What was the situation before your organisation adopted a sustainability purpose, objectives and interventions?" do
          classes "word-max-strict sub-question"
          ref "C 2.2"
          required
          rows 2
          words_max 200
        end

        textarea :why_these_particular_interventions,
                 "Why did you choose these particular interventions, and how do they align with the core aims and values of your organisation?" do
          classes "word-max-strict sub-question"
          ref "C 2.3"
          required
          rows 3
          words_max 300
        end

        textarea :how_have_you_embedded_sustainability_objectives,
                 "How have you embedded sustainability objectives or purpose in your organisation?" do
          classes "word-max-strict sub-question"
          ref "C 2.4"
          required
          rows 2
          words_max 200
        end

        textarea :explain_how_the_business_operates_sustainably,
                 "If your application is focused on particular sustainable development interventions, explain how your whole business also operates sustainably, especially in terms of climate change." do
          classes "word-max-strict sub-question"
          ref "C 2.5"
          required
          context %{
            <p>
              At a minimum, we expect all winning organisations to have good practices around climate change. Therefore, if your sustainable development interventions are not climate focused, describe:
            </p>
            <ul>
              <li>Your strategy and approach related to climate change.</li>
              <li>Your climate change related targets. Be clear whether your targets are for carbon neutrality or, if you go further, aiming for “net zero” or beyond.</p>
              <li>If you operate in an extractive or less environmentally sustainable industry, please explain how your business minimises the environmental impact. Where relevant, please list ISO accreditations.</li>
              <li>If your business uses packaging, please provide information on how you are working towards minimising the impact of the packaging on the environment.</li>
              <li>How you have measured your emissions.</li>
              <li>Other areas that show your organisation operates sustainably, such as being part of the circular economy, or reductions in hazardous waste and plastics (if relevant).</li>
            </ul>
            <p><strong>Carbon offsetting</strong><p>
            <p>Where carbon offsetting has been used as part of your carbon reduction strategy, we expect complete transparency on the volumes and types of carbon credits purchased and retired. Please specify:</p>
            <ul>
              <li>the volume of high-quality carbon credits retired as a % of a company's remaining emissions once it has demonstrated progress towards its near-term emission reduction targets.</li>
              <li>the type of carbon credits purchased by specifying the project type, geography, vintage year and how they are certified.</li>
            </ul>
            <p>Credits can be either emission reductions or removal achieved outside the value chain of the company. This is also referred to as 'beyond value chain mitigation'.</p>
            <p>
              Please note, if your application is focused on climate change, do not repeat climate change related information in your answer to C2.5, just state that it's covered in other answers.
            </p>
          }
          pdf_context %(
            At a minimum, we expect all winning organisations to have good practices around climate change. Therefore, if your sustainable development interventions are not climate focused, describe:

            \u2022 Your strategy and approach related to climate change.
            \u2022 Your climate change related targets. Be clear whether your targets are for carbon neutrality or, if you go further, aiming for “net zero” or beyond.
            \u2022 If you operate in an extractive or less environmentally sustainable industry, please explain how your business minimises the environmental impact. Where relevant, please list ISO accreditations.
            \u2022 If your business uses packaging, please provide information on how you are working towards minimising the impact of the packaging on the environment.
            \u2022 How you have measured your emissions.
            \u2022 Other areas that show your organisation operates sustainably, such as being part of the circular economy, or reductions in hazardous waste and plastics (if relevant).

            Carbon offsetting

            Where carbon offsetting has been used as part of your carbon reduction strategy, we expect complete transparency on the volumes and types of carbon credits purchased and retired. Please specify:

            \u2022 the volume of high-quality carbon credits retired as a % of a company's remaining emissions once it has demonstrated progress towards its near-term emission reduction targets.
            \u2022 the type of carbon credits purchased by specifying the project type, geography, vintage year and how they are certified.

            Credits can be either emission reductions or removal achieved outside the value chain of the company. This is also referred to as 'beyond value chain mitigation'.

            Please note, if your application is focused on climate change, do not repeat climate change related information in your answer to C2.5, just state that it's covered in other answers.
          )
          rows 2
          words_max 400
        end

        textarea :how_sustainability_interventions_benefit_business_strategy,
                 "How do sustainability interventions benefit the overall business strategy?" do
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
          context %(
            <p>
              For example, how are you changing your business to respond to future sustainability challenges in your business or sector?
            </p>
          )
          rows 2
          words_max 200
        end

        header :leadership_and_management, "Leadership and management" do
          ref "C 3"
          context %(
            <p class="govuk-hint">
              In questions C3.1 to C3.8, describe the driving force of your organisation's sustainability.
            </p>
          )
        end

        textarea :describe_the_driving_force_of_your_organisation,
                 "Who is ultimately responsible for the organisation's sustainability interventions and their success?" do
          classes "word-max-strict sub-question"
          ref "C 3.1"
          required
          rows 2
          words_max 200
        end

        textarea :who_is_responsible_for_day_to_day_management,
                 "Who is responsible for the day-to-day management, and the main areas of sustainability, in your organisation?" do
          classes "word-max-strict sub-question"
          ref "C 3.2"
          required
          context %(
            <p>You may include flow charts to make it easier for assessors to understand how your programme is managed in section E of this form.</p>
          )
          rows 2
          words_max 200
        end

        textarea :describe_the_senior_decision_makers_commitment_to_sustainability,
                 "What is the senior decision maker's commitment to the future sustainable growth of the organisation?" do
          classes "word-max-strict sub-question"
          ref "C 3.3"
          required
          rows 2
          words_max 200
        end

        textarea :how_does_your_organisation_inspire_others,
                 "How does your organisation inspire other organisations to be more sustainable?" do
          classes "word-max-strict sub-question"
          ref "C 3.4"
          required
          context %(
            <p>
              For example, businesses in your supply chain, stakeholders, customers, local communities or even competitors.
            </p>
          )
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

        textarea :describe_your_organisation_diversity,
                 "How does your organisation attract, recruit, promote and retain a diverse workforce?" do
          classes "word-max-strict sub-question"
          ref "C 3.6"
          required
          context %(
            <p>
              Describe your organisation's diversity and inclusion strategy and any policies, and provide evidence that they are effective. Include data on how employees with protected characteristics are represented in your workforce.
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :describe_how_employee_relations_improved_their_motivation,
                 "How do you ensure workforce motivation, well-being and satisfaction?" do
          classes "word-max-strict sub-question"
          ref "C 3.7"
          required
          rows 2
          words_max 200
        end

        header :culture_and_values, "Culture and values regarding sustainability" do
          ref "C 4"
          context %(
            <p class="govuk-hint">
              In questions C4.1 to C4.4, describe how your organisation's culture fosters and supports sustainability.
            </p>
          )
        end

        textarea :culture_and_values_regarding_sustainability,
                 "How is sustainability embedded in your organisation's culture and values?" do
          classes "word-max-strict sub-question"
          ref "C 4.1"
          required
          rows 2
          words_max 200
        end

        textarea :how_do_you_increase_positive_perception_of_sustainability,
                 "How do you increase positive perceptions of your organisation's sustainability among stakeholders, such as your workforce, supply chain, customers, communities, and media?" do
          classes "word-max-strict sub-question"
          ref "C 4.2"
          context %(
            <p>
              Please state how you communicate the impact of your sustainability interventions to the various stakeholders.
            </p>
            <p>
              Include links to relevant pages on your company's website, social media or alternative channels where you demonstrate your leadership in sustainable development.
            </p>
            <p>
              If applicable, include in your answer or attach in section E of this form: newsletters, quotes or similar materials to bring to life how you communicate the value you place on sustainability.
            </p>
          )
          required
          rows 4
          words_max 400
        end

        textarea :what_are_your_long_term_plans_for_sustainability,
                 "What are your long-term plans for ensuring your organisation provides the leadership, innovation or interventions to enable greater sustainable development?" do
          classes "word-max-strict sub-question"
          ref "C 4.3"
          required
          rows 2
          words_max 200
        end

        header :sustainable_development_interventions_header, "Your sustainable development interventions in detail" do
          ref "C 5"
          context %(
            <p class="govuk-hint">
              In questions C5.1 to C5.4, describe your interventions using the UN SDGs to structure your answer to each section, but only where relevant.
            </p>
            <p class="govuk-hint">
              You need to summarise your interventions for sustainable development and demonstrate a sustainable strategy across the business.
            </p>
          )
        end

        textarea :describe_your_interventions_using_un, "Which UN SDGs are your efforts targeted towards?" do
          required
          classes "word-max-strict sub-question"
          sub_ref "C 5.1"
          context %(
            <p>
              Please note, you do not need to address each UN SDG, only the ones that are most applicable to your sustainable development interventions.
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :aims_of_the_interventions, "The aims of the interventions." do
          classes "word-max-strict sub-question"
          ref "C 5.2"
          required
          context %(
            <p>
              For example, this could be, to regenerate, to restore, to reduce emissions or to promote good health and wellbeing within the local community and society in general.
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :proportion_of_interventions_compared_to_organisation_size,
                 "The proportion of these interventions compared to your whole organisation's size." do
          classes "word-max-strict sub-question"
          ref "C 5.3"
          required
          context %(
            <p>
              For instance, does your sustainable development activity relate to the whole organisation or just part of it?
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :evidence_of_exemplary_interventions, "Provide evidence of what makes your interventions exemplary." do
          classes "word-max-strict sub-question"
          ref "C 5.4"
          required
          context %(
            <p>
              For example, they may be exemplary as a result of:
            </p>
            <ul>
              <li>An overall strategy where complementary programmes are linked to form a powerful series of engagements to inform, inspire, guide, recruit or develop people.</li>
              <li>Developing unique or innovative ways to be sustainable.</li>
              <li>Forming effective partnerships with other organisations, for example, businesses in your supply chain, charities or schools.</li>
              <li>Leading the way in your company, sector or market by doing something that has never been done before.</li>
            </ul>
            <p>
              If you have any external documents or other media to support your answer, please add these in Section E and reference them by their names in your answers.
            </p>
          )
          pdf_context %(
            For example, it may be exemplary as a result of:

            \u2022 An overall strategy where complementary programmes are linked to form a powerful series of engagements to inform, inspire, guide, recruit or develop people.
            \u2022 Developing unique or innovative ways to be sustainable.
            \u2022 Forming effective partnerships with other organisations, for example, businesses in your supply chain, charities or schools.
            \u2022 Leading the way in your company, sector or market by doing something that has never been done before.

            If you have any external documents or other media to support your answer, please add these in Section E and reference them by their names in your answers.
          )
          rows 4
          words_max 400
        end

        header :sustainable_development_impact_header, "Impact of your sustainable development " do
          ref "C 6"
          context %{
            <p class="govuk-hint">
              In questions C6.1 to C6.6, describe the impact of your initiative. Focus on what impact your activities have achieved to date but include the longer-term outcomes as well.
            </p>
            <p class="govuk-hint">
              Wherever possible, use a balance of quantitative (for example, numbers and figures) and qualitative (for example, comments, feedback from people, main stakeholders) evidence to support your application.
            </p>
          }
        end

        textarea :how_do_you_measure_the_success_of_interventions, "How do you measure the success of your sustainability intervention?" do
          ref "C 6.1"
          classes "word-max-strict sub-question"
          required
          context %(
            <p>For example, are key performance indicators (KPIs) or targets used? If so, how are they set and monitored? Are the KPIs or targets being met, and what happens if they are not?</p>
          )
          rows 3
          words_max 300
        end

        textarea :what_qualitive_measures_were_used_to_measure_success,
                 "State what qualitative measures were used to evaluate the success of your sustainable business objectives to your organisation, customers, workforce or others in meeting objectives for performance." do
          ref "C 6.2"
          classes "word-max-strict sub-question"
          required
          rows 3
          words_max 300
        end

        textarea :impact_of_your_sustainable_development, "The impact of your sustainable objectives." do
          classes "word-max-strict sub-question"
          ref "C 6.3"
          required
          context %(
            <p>
              Describe the impact on your organisation, workforce, customers, stakeholders, supply chain, communities, regions or others, such as overseas clients or markets and how you are part of the circular economy.
            </p>
          )
          rows 3
          words_max 300
        end

        textarea :how_does_the_scale_of_intervention_compare_to_others,
                 "How does the scale of your interventions compare with other organisations in your sector?" do
          classes "word-max-strict sub-question"
          ref "C 6.4"
          required
          context %(
            <p>
              Explain and, if possible, provide evidence or research on how you have compared your organisation to others in your sector, including a web link if available.
            </p>
            <p>
              Explain how you know that your sustainability performance is exemplary compared with the sector in general.
            </p>
          )
          rows 3
          words_max 300
        end

        textarea :what_longer_term_outcomes_do_you_expect,
                 "What longer-term outcomes do you expect as a result of your sustainable development efforts?" do
          classes "word-max-strict sub-question"
          ref "C 6.5"
          required
          rows 2
          words_max 200
        end

        textarea :which_accreditations_have_been_achieved,
                 "If your organisation has achieved recognised standards or accreditations, please list them." do
          classes "word-max-strict sub-question"
          ref "C 6.6"
          required
          context %(
            <p>
              For example, ISO 14000 group of standards or B-Corp accreditation. If you haven't achieved such standards or accreditations, please explain and, if possible, illustrate what processes you have in place to maintain standards.
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :governance, "Additional information about your Environmental, Social, and Corporate Governance (ESG). (optional)" do
          classes "word-max-strict sub-question"
          ref "C 6.7"
          context %(
            <p>
              Please highlight your responsible business conduct and its impact within your organisation, supply chain and the wider community, if not already covered.
            </p>
          )
          rows 2
          words_max 200
        end
      end
    end
  end
end
