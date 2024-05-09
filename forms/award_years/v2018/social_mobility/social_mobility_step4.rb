# -*- coding: utf-8 -*-

class AwardYears::V2018::QaeForms
  class << self
    def mobility_step4
      @mobility_step4 ||= proc do
        header :complete_now_header, "" do
          context %(
            <p>
              All applicants for any Queen’s Award must demonstrate how they meet commonly accepted standards for corporate responsibility. Applicants who are not able to demonstrate strong corporate social responsibility will not be successful.
            </p>
            <p>
              The Declaration of Corporate Responsibility is a chance for you to outline your responsible business conduct, and its social, economic and environmental impact.
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

        header :declaration_and_corporate_responsibility_intro, "" do
          classes "application-notice help-notice"
          context %(
            <p>
              You may have answered some of the questions in this section in other parts of the form.
            </p>
            <p>
              If you believe this is the case, you do not need to repeat the information, but make it clear by referencing other parts of the form.
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

        textarea :customers_relations, "Relations with customers" do
          ref "D 4"
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
          sub_ref "D 5"
          required
          show_ref_always true
          text "I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a Queen's Award for Enterprise."
        end
      end
    end
  end
end
