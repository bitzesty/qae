# -*- coding: utf-8 -*-
class AwardYears::V2020::QaeForms
  class << self
    def trade_step4
      @trade_step4 ||= proc do
        header :complete_now_header, "" do
          context %(
            <h3>About this section</h3>
            <p>
              The Declaration of Corporate Responsibility is a chance for you to show your responsible business conduct and its social, economic and environmental impact. All applicants for a Queen’s Award for Enterprise must demonstrate how they meet commonly accepted standards for corporate responsibility. Applicants who are not able to demonstrate corporate social responsibility will not be successful.
            </p>
            <h3>Small organisations</h3>
            <p>
              We recognise that for many smaller organisations the extent to which they can deliver high impact Corporate Responsibility may be limited. Given this, please answer the questions in a way that best suits your organisation.
            </p>
            <h3>Answering questions</h3>
            <p>
              The guidance notes below each section are not exhaustive. Where possible, please support your answers with quantitative evidence of your initiatives, improvements and successes; and describe any relevant policies or handbooks that you have in place.
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
            )]
          ]
        end

        header :declaration_and_corporate_responsibility_intro, "" do
          classes "application-notice help-notice"
          context %(
            <p>
              You may have answered some of the questions in this section in other parts of the form. If you believe this is the case, you do not need to repeat the information, but make it clear by referencing other parts of the form.
            </p>
            <p>
              Please use this section to give us additional information about corporate responsibility that you have not covered elsewhere in the form and would like us to see.
            </p>
          )
        end

        textarea :impact_on_society, "The impact of your business operations on society" do
          ref "D 1"
          required
          context %(
            <p>
              How does your business try to ensure a beneficial impact of all your practices and activites on society?
            </p>
            <p>
              What activities do you undertake to foster good relations with local communities? Outline how you evaluate and report on their impact.
            </p>
            <p>
              If you have operations in emerging or developing markets, are these conducted with proper regard for the current and future welfare of the people employed there?
            </p>
          )
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

        textarea :employees_relations, "Relations with employees" do
          ref "D 3"
          required
          context %(
            <p>
              Do you have a code of conduct or employee policies? For example, health and safety, training, staff welfare, whistleblowing and equal opportunities.
            </p>
            <p>
              Do you offer any special employment conditions? For example, flexible working, extended maternity pay.
            </p>
            <p>
              How do you keep your employees engaged? For example, communication, assessments, incentives, opportunities for career development.
            </p>
            <p>
              How are you training and developing your staff?
            </p>
            <p>
              Do you encourage/support them to learn new skills and gain new qualifications?
            </p>
            <p>
              Do you take on apprentices, and if so, how many?
            </p>
          )
          rows 5
          words_max 250
        end

        textarea :partners_relations, "Relations with customers and suppliers" do
          ref "D 4"
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
          sub_ref "D 5"
          required
          show_ref_always true
          text "I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a Queen's Award for Enterprise."
        end
      end
    end
  end
end
