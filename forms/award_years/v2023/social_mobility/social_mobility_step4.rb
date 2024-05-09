# -*- coding: utf-8 -*-

class AwardYears::V2023::QaeForms
  class << self
    def mobility_step4
      @mobility_step4 ||= proc do
        header :complete_now_header, "" do
          section_info
          context %(
            <h3 class="govuk-heading-m">About section D</h3>
            <p class="govuk-body">
              The Declaration of Corporate Social Responsibility is an opportunity for you to highlight your responsible business conduct and its social, economic and environmental impact within your organisation, supply chain and wider community. We expect all applicants for a Queen's Award for Enterprise to adhere to commonly accepted standards for corporate responsibility. Provide examples for each heading, relative to the size and scale of your business. For this section, you may wish to consider the following points: How do you invest in employees, or select suppliers with the same high standards? Do you provide opportunities such as mentoring, coaching or work experience placements? How have you reduced your carbon footprint? Applicants who are not able to demonstrate corporate social responsibility will not be successful.
            </p>
            <h3 class="govuk-heading-m">Answering questions</h3>
            <p class="govuk-body">
              The word limits are a guide. You do not need to completely fill in every box if there is no reason to - we suggest you focus on your strongest examples in each case.
            </p>
            <p class="govuk-body">
              Furthermore, you may have answered some of the questions in this section in other parts of the form - such as the questions relating to your innovation's value-add in B3. If you believe this is the case, you do not need to repeat the information but make it clear by referencing the questions in other parts of the form.
            </p>
            <p class="govuk-body">
              The guidance notes below each section are not exhaustive. Where possible, please support your answers with quantitative evidence of your initiatives, improvements and successes; and describe any relevant policies or procedures that you have in place.
            </p>
            <p class="govuk-body">
              Finally, there is no need to provide information on how you are adhering to statutory laws or regulations - such as 'we pay minimum wage'. We're more interested in how you are going above and beyond.
            </p>
            <h3 class="govuk-heading-m">Small organisations</h3>
            <p class="govuk-body">
              Queen's Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all of the questions to a degree you can.
            </p>
          )

          pdf_context_with_header_blocks [
            [:bold, "About section D"],
            [:normal, %(
              The Declaration of Corporate Social Responsibility is an opportunity for you to highlight your responsible business conduct and its social, economic and environmental impact within your organisation, supply chain and wider community. We expect all applicants for a Queen's Award for Enterprise to adhere to commonly accepted standards for corporate responsibility. Provide examples for each heading, relative to the size and scale of your business. For this section, you may wish to consider the following points: How do you invest in employees, or select suppliers with the same high standards? Do you provide opportunities such as mentoring, coaching or work experience placements? How have you reduced your carbon footprint? Applicants who are not able to demonstrate corporate social responsibility will not be successful.
            )],
            [:bold, "Answering questions"],
            [:normal, %(
              The word limits are a guide. You do not need to completely fill in every box if there is no reason to - we suggest you focus on your strongest examples in each case.

              Furthermore, you may have answered some of the questions in this section in other parts of the form - such as the questions relating to your innovation's value-add in B3. If you believe this is the case, you do not need to repeat the information but make it clear by referencing the questions in other parts of the form.

              The guidance notes below each section are not exhaustive. Where possible, please support your answers with quantitative evidence of your initiatives, improvements and successes; and describe any relevant policies or procedures that you have in place.

              Finally, there is no need to provide information on how you are adhering to statutory laws or regulations - such as 'we pay minimum wage'. We're more interested in how you are going above and beyond.
            )],
            [:bold, "Small organisations"],
            [:normal, %(
              Queen's Awards for Enterprise is committed to acknowledging efforts of organisations of all sizes. When assessing, we consider the size and sector of your organisation. If you are a small organisation, do not be intimidated by the questions that are less relevant to you - answer all of the questions to a degree you can.
            )],
          ]
        end

        textarea :impact_on_society, "The impact of your business operations on society." do
          ref "D 1"
          required
          context %(
            <p>
              You may wish to describe:
            </p>
            <ul>
              <li>How your business ensures that your activities have a beneficial impact on society and your local community.</li>
              <li>If you have operations in emerging or developing markets, please describe how you ensure the current and future welfare of the people employed there.</li>
              <li>What impact your organisation has on society and your local community that results from your activities that are beyond your core business. For example, apprenticeship programmes, supporting disadvantaged groups, and charitable activities.</li>
              <li>How you evaluate and report on that impact.</li>
            </ul>
          )
          pdf_context %(
            <p>
              You may wish to describe:
            </p>
            <p>
              \u2022 How your business ensures that your activities have a beneficial impact on society and your local community.

              \u2022 If you have operations in emerging or developing markets, please describe how you ensure the current and future welfare of the people employed there.

              \u2022 What impact your organisation has on society and your local community that results from your activities that are beyond your core business. For example, apprenticeship programmes, supporting disadvantaged groups, and charitable activities.

              \u2022 How you evaluate and report on that impact.
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :impact_on_environment, "The environmental impact of your business operations." do
          ref "D 2"
          required
          context %(
            <p>
              You may wish to describe:
            </p>
            <ul>
              <li>Any environmental considerations within your business. For example, energy efficiency strategies, recycling policies, and emissions reduction policies.</li>
              <li>If and how you undertake environmental impact assessments of major projects.</li>
              <li>How environmental considerations and the efficient use of resources are built into your business, products or services.</li>
            </ul>
          )
          pdf_context %(
            <p>
              You may wish to describe:
            </p>
            <p>
              \u2022 Any environmental considerations within your business. For example, energy efficiency strategies, recycling policies, and emissions reduction policies.

              \u2022 If and how you undertake environmental impact assessments of major projects.

              \u2022 How environmental considerations and the efficient use of resources are built into your business, products or services.
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :employees_relations, "Relations with employees." do
          ref "D 3"
          required
          context %(
            <p>
              You may wish to describe:
            </p>
            <ul>
              <li>If you have a code of conduct or employee policies. For example, health and safety, training, staff welfare, whistleblowing and equal opportunities.</li>
              <li>If you offer any special employment conditions. For example, flexible working or extended maternity pay.</li>
              <li>How you keep your employees engaged. For example, communication, assessments, incentives and opportunities for career development.</li>
              <li>How you are training and developing your staff. For example, if you encourage or support them to learn new skills and gain new qualifications.</li>
              <li>If you take on apprentices, and if so, how many.</li>
            </ul>
          )
          pdf_context %(
            <p>
              You may wish to describe:
            </p>
            <p>
              \u2022 If you have a code of conduct or employee policies. For example, health and safety, training, staff welfare, whistleblowing and equal opportunities.

              \u2022 If you offer any special employment conditions. For example, flexible working or extended maternity pay.

              \u2022 How you keep your employees engaged. For example, communication, assessments, incentives and opportunities for career development.

              \u2022 How you are training and developing your staff. For example, if you encourage or support them to learn new skills and gain new qualifications.

              \u2022 If you take on apprentices, and if so, how many.
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :partners_relations, "Relations with customers and suppliers." do
          ref "D 4"
          required
          context %(
            <p>
              You may wish to describe:
            </p>
            <ul>
              <li>How you encourage your suppliers to meet ethical standards.</li>
              <li>To what extent you are sourcing or encouraging your supply chain to source UK goods and services.</li>
              <li>By what criteria you select clients and ensure they are appropriate for your services.</li>
              <li>How you measure customer satisfaction - and what the results have been.</li>
            </ul>
          )
          pdf_context %(
            <p>
              You may wish to describe:
            </p>
            <p>
              \u2022 How you encourage your suppliers to meet ethical standards.

              \u2022 To what extent you are sourcing or encouraging your supply chain to source UK goods and services.

              \u2022 By what criteria you select clients and ensure they are appropriate for your services.

              \u2022 How you measure customer satisfaction - and what the results have been.
            </p>
          )
          rows 2
          words_max 200
        end

        textarea :governance, "Governance." do
          ref "D 5"
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
