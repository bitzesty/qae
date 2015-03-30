class QAE2014Forms
  class << self
    def development_step4
      @development_step4 ||= proc do
        options :corp_responsibility_form, "The full corporate responsibility form is only required for applications that are shortlisted. You can complete it now, or make a declaration now and complete the full version if your application gets shortlisted." do
          ref "D 1"
          required
          context %(
            <p>This decision doesn't affect your chance of success.</p>
                    )
          option :complete_now, "Complete full corporate responsibility form now"
          option :declare_now, "Complete declaration now, and full form once shortlisted"
        end

        header :complete_now_header, "" do
          context %(
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
            <p>
              If you have already provided relevant information in your entry, please refer to that information and give any additional information under the relevant heading(s) below.
            </p>
          )
          conditional :corp_responsibility_form, :complete_now
        end

        textarea :impact_on_society, "The impact of your business operations on society" do
          ref "D 2"
          required
          context %(
            <p>
              How does your business try to ensure a beneficial impact of all your practices and activites on society?
            </p>
            <p>
              What activities do you undertake to foster good relations with local communities? Outline how you evaluate and report on their impact.
            </p>
            <p>
              If you have operations in the third world or developing countries, are these conducted with proper regard for the current and future welfare of the people employed there?
            </p>
          )
          rows 5
          words_max 500
          conditional :corp_responsibility_form, :complete_now
        end

        textarea :impact_on_environment, "The environmental impact of your business operations" do
          ref "D 3"
          required
          conditional :corp_responsibility_form, :complete_now
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
          ref "D 4"
          required
          conditional :corp_responsibility_form, :complete_now
          context %(
            <p>
              Outline your selection criteria, if any, with regard to potential suppliers'/partners'/contractors' economic, social and environmental performance.
            </p>
            <p>
              Do you encourage best practice or require them to meet your own standards? To what extent are you succeeding?
            </p>
                    )
          rows 5
          words_max 500
        end

        textarea :employees_relations, "Relations with employees" do
          ref "D 5"
          required
          conditional :corp_responsibility_form, :complete_now
          context %(
            <p>
              Do you have a code of conduct and/or employee policies? e.g. health and safety, training, staff welfare, whistleblowing and equal opportunities
            </p>
            <p>
              Do you offer any special employment conditions? e.g. flexible working, extended maternity pay
            </p>
            <p>
              How do you keep your employees engaged? e.g. communication, assessments, incentives, opportunities for career development
            </p>
                    )
          rows 5
          words_max 500
        end

        textarea :customers_relations, "Relations with customers" do
          ref "D 6"
          required
          conditional :corp_responsibility_form, :complete_now
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
          required
          text "I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a Queen's Award for Enterprise."
          conditional :corp_responsibility_form, :declare_now
        end
      end
    end
  end
end
