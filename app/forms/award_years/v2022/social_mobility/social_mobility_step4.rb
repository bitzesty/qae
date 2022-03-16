# -*- coding: utf-8 -*-
class AwardYears::V2022::QAEForms
  class << self
    def mobility_step4
      @mobility_step4 ||= proc do
        header :complete_now_header, "" do
          section_info
          context %(
            <h3 class="govuk-heading-m">About this section</h3>
            <p class="govuk-body">
              The Declaration of Corporate Responsibility is a chance for you to show your responsible business conduct and its social, economic and environmental impact. All applicants for a Queen’s Award for Enterprise must demonstrate how they meet commonly accepted standards for corporate responsibility. Applicants who are not able to demonstrate corporate social responsibility will not be successful.
            </p>
            <h3 class="govuk-heading-m">Small organisations</h3>
            <p class="govuk-body">
              We recognise that for many smaller organisations the extent to which they can deliver high impact Corporate Responsibility may be limited. Given this, please answer the questions in a way that best suits your organisation.
            </p>
            <h3 class="govuk-heading-m">Answering questions</h3>
            <p class="govuk-body">
              The guidance notes below each section are not exhaustive. Where possible, please support your answers with quantitative evidence of your initiatives, improvements and successes; and describe any relevant policies or handbooks that you have in place.
            </p>
            <p class="govuk-body">
              If you have already answered a question in another section in the application form, you can reference the relevant question number(s).
            </p>
          )

          pdf_context_with_header_blocks [
            [:bold, "About this section"],
            [:normal, %(
              The Declaration of Corporate Responsibility is a chance for you to show your responsible business conduct and its social, economic and environmental impact. All applicants for a Queen’s Award for Enterprise must demonstrate how they meet commonly accepted standards for corporate responsibility. Applicants who are not able to demonstrate corporate social responsibility will not be successful.
            )],
            [:bold, "Small organisations"],
            [:normal, %(
              We recognise that for many smaller organisations the extent to which they can deliver high impact Corporate Responsibility may be limited. Given this, please answer the questions in a way that best suits your organisation.
            )],
            [:bold, "Answering questions"],
            [:normal, %(
              The guidance notes below each section are not exhaustive. Where possible, please support your answers with quantitative evidence of your initiatives, improvements and successes; and describe any relevant policies or handbooks that you have in place.

              If you have already answered a question in another section in the application form, you can reference the relevant question number(s).
            )]
          ]
        end

        header :declaration_and_corporate_responsibility_intro, "" do
          classes "application-notice help-notice"
          context %(
            <p>
              Please use this section to give us additional information about corporate responsibility that you have not covered elsewhere in the form and would like us to see.
            </p>
          )
        end

        textarea :impact_on_society, "The impact of your business operations on society" do
          ref "D 1"
          required
          context %{
            <p>
              a) How does your business ensure that your activities have a beneficial impact on society and your local community? If you have operations in emerging or developing markets, please describe how you ensure the current and future welfare of the people employed there.
            </p>
            <p>
              b) What impact your organisation has on society and your local community that results from your activities that are beyond your core business? For example, apprenticeship programmes, supporting any disadvantaged groups, charitable activities.
            </p>
            <p>
              Outline how you evaluate and report on the impact.
            </p>
          }
          rows 5
          words_max 250
        end

        textarea :impact_on_environment, "The environmental impact of your business operations" do
          ref "D 2"
          required
          context %(
            <p>
              Describe any environmental considerations within your business. For example, energy efficiency strategies, recycling policies, emissions reduction policies.
            </p>
            <p>
              State if and how you undertake environmental impact assessments of major projects.
            </p>
            <p>
              How are environmental considerations and efficient use of resources built into your business/ products/ services?
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :partners_relations, "Relations with customers and suppliers" do
          ref "D 3"
          required
          context %(
            <p>
              How do you encourage your suppliers to meet ethical standards?
            </p>
            <p>
              To what extent are you sourcing or encouraging your supply chain to source UK goods and services?
            </p>
            <p>
              By what criteria do you select clients and ensure they are appropriate for your services?
            </p>
            <p>
              How do you measure customer satisfaction and what have been the results?
            </p>
            <p>
              By what criteria do you select clients and ensure they are appropriate for your services?
            </p>
          )
          rows 5
          words_max 250
        end

        confirm :declaration_of_corporate_responsibility, "" do
          sub_ref "D 4"
          required
          show_ref_always true
          text "I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a Queen's Award for Enterprise."
        end
      end
    end
  end
end
