# -*- coding: utf-8 -*-

class AwardYears::V2018::QaeForms
  class << self
    def innovation_step4
      @innovation_step4 ||= proc do
        header :complete_now_header, "" do
          context %(
            <p>
              All applicants for any Queen’s Award must demonstrate how they meet commonly accepted standards for corporate responsibility. Applicants who are not able to demonstrate strong corporate social responsibility will not be successful.
            </p>
            <p>
              The Declaration of Corporate Responsibility is a chance for you to outline your responsible business conduct, and its social, economic and environmental impact.
            </p>
            <p>
              You don't have to demonstrate strength in all of the areas below.
            </p>
            <p>
              The guidance notes below each section are not exhaustive. Answer the questions in a way that best suits your organisation.
            </p>
            <p>
              If you can give quantitative evidence of your initiatives/improvement/success, then do so.
            </p>
            <p>
              If you have too many initiatives, just outline the ones you think are most relevant/important.
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
          words_max 500
        end

        textarea :impact_on_environment, "The environmental impact of your business operations" do
          ref "D 2"
          required
          context %(
            <p>
              Describe any environmental considerations within your business e.g. energy efficiency strategies, recycling policies, emissions reduction policies.
            </p>
            <p>
              State if and how you undertake environmental impact assessments of major projects.
            </p>
            <p>
              Are environmental considerations and efficient use of resources built into your business/products/services?
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :partners_relations, "Relations with suppliers, partners and contractors" do
          ref "D 3"
          required
          context %(
            <p>
              Outline your selection criteria, if any, with regard to potential suppliers'/partners'/contractors' economic, social and environmental performance.
            </p>
            <p>
              For example, do you encourage best practice or require them to meet your own standards? To what extent are you succeeding? How proactive are you at encouraging your supply chain to source British goods/products/services? Do you mentor businesses in your supply chain – if so how?
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :employees_relations, "Relations with employees" do
          ref "D 4"
          required
          context %(
            <p>
              Do you have a code of conduct and/or employee policies? e.g. health and safety, training, staff welfare, whistleblowing and equal opportunities.
            </p>
            <p>
              Do you offer any special employment conditions? e.g. flexible working, extended maternity pay.
            </p>
            <p>
              How do you keep your employees engaged? e.g. communication, assessments, incentives, opportunities for career development.
            </p>
            <p>
              How are you training and developing your staff?
              Do you encourage/support them to learn new skills and gain new qualifications?
            </p>
            <p>
              Do you take on apprentices, and if so, how many?
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :customers_relations, "Relations with customers" do
          ref "D 5"
          required
          context %(
            <p>
              What proportion of your sales consist of repeat purchases?
            </p>
            <p>
              How do you measure customer satisfaction, and what have been the results?
            </p>
            <p>
              By what criteria do you select clients and ensure they are appropriate for your services?
            </p>
          )
          rows 5
          words_max 500
        end

        confirm :declaration_of_corporate_responsibility, "" do
          sub_ref "D 6"
          required
          show_ref_always true
          text "I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a Queen's Award for Enterprise."
        end
      end
    end
  end
end
