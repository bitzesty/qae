# -*- coding: utf-8 -*-
class AwardYears::V2025::QaeForms
  class << self
    def mobility_step5
      @mobility_step5 ||= proc do
        about_section :complete_now_header, "" do
          section "mobility_ESG"
        end

        textarea :impact_on_society, "The impact of your business operations on society." do
          ref "E 1"
          required
          context %(
            <p>
              Examples of areas you may wish to describe:
            </p>
            <ul>
              <li>How your business ensures that your activities have a beneficial impact on society and your local community.</li>
              <li>If you have operations in emerging or developing markets, please describe how you ensure the current and future welfare of your workforce there.</li>
              <li>What impact your organisation has on society and your local community that results from your activities that are beyond your core business? For example, apprenticeship programmes, supporting disadvantaged groups, and charitable activities.</li>
              <li>How you evaluate and report on that impact.</li>
            </ul>
          )
          pdf_context %(
            Examples of areas you may wish to describe:

            \u2022 How your business ensures that your activities have a beneficial impact on society and your local community.

            \u2022 If you have operations in emerging or developing markets, please describe how you ensure the current and future welfare of your workforce there.

            \u2022 What impact your organisation has on society and your local community that results from your activities that are beyond your core business? For example, apprenticeship programmes, supporting disadvantaged groups, and charitable activities.

            \u2022 How you evaluate and report on that impact.
          )
          rows 2
          words_max 200
        end

        textarea :impact_on_environment, "The environmental impact of your business operations." do
          ref "E 2"
          required
          context %(
            <p>
              Examples of areas you may wish to describe:
            </p>
            <ul>
              <li>Any environmental considerations within your business. For example, energy efficiency strategies, recycling policies, and emissions reduction policies.</li>
              <li>If and how you undertake environmental impact assessments of major projects.</li>
              <li>How environmental considerations and the efficient use of resources are built into your business, products or services.</li>
              <li>How you have reduced your carbon footprint.</li>
            </ul>
          )
          pdf_context %(
            Examples of areas you may wish to describe:

          \u2022 Any environmental considerations within your business. For example, energy efficiency strategies, recycling policies, and emissions reduction policies.

          \u2022 If and how you undertake environmental impact assessments of major projects.

          \u2022 How environmental considerations and the efficient use of resources are built into your business, products or services.

          \u2022 How you have reduced your carbon footprint.
          )
          rows 2
          words_max 200
        end

        textarea :employees_relations, "Relations with your workforce." do
          ref "E 3"
          required
          context %(
            <p>
              Examples of areas you may wish to describe:
            </p>
            <ul>
              <li>If you have a code of conduct or workforce policies. For example, health and safety, training, welfare, whistleblowing and equal opportunities.</li>
              <li>If you offer any special working conditions. For example, flexible working or extended maternity pay.</li>
              <li>How you keep your workforce engaged. For example, communication, assessments, incentives and opportunities for career development.</li>
              <li>How you are training and developing your workforce. For example, if you provide mentoring or coaching, encourage or support them to learn new skills and gain new qualifications.</li>
              <li>If you have work placements or take on apprentices, and if so, how many?</li>
            </ul>
          )
          pdf_context %(
            Examples of areas you may wish to describe:

            \u2022 If you have a code of conduct or workforce policies. For example, health and safety, training, welfare, whistleblowing and equal opportunities.

            \u2022 If you offer any special working conditions. For example, flexible working or extended maternity pay.

            \u2022 How you keep your workforce engaged. For example, communication, assessments, incentives and opportunities for career development.

            \u2022 How you are training and developing your workforce. For example, if you provide mentoring or coaching, encourage or support them to learn new skills and gain new qualifications.

            \u2022 If you have work placements or take on apprentices, and if so, how many?
          )
          rows 2
          words_max 200
        end

        textarea :partners_relations, "Relations with customers and suppliers." do
          ref "E 4"
          required
          context %(
            <p>
              Examples of areas you may wish to describe:
            </p>
            <ul>
              <li>How do you encourage your suppliers to meet ethical standards?</li>
              <li>To what extent are you sourcing or encouraging your supply chain to source UK goods and services?</li>
              <li>By what criteria do you select clients and ensure they are appropriate for your services?</li>
              <li>How you measure customer satisfaction - and what the results have been.</li>
            </ul>
          )
          pdf_context %(
            Examples of areas you may wish to describe:

            \u2022 How do you encourage your suppliers to meet ethical standards?

            \u2022 To what extent are you sourcing or encouraging your supply chain to source UK goods and services?

            \u2022 By what criteria do you select clients and ensure they are appropriate for your services?

            \u2022 How you measure customer satisfaction - and what the results have been.
          )
          rows 2
          words_max 200
        end

        textarea :governance, "Additional environmental, social, and corporate governance (ESG) examples. (optional)" do
          ref "E 5"
          required
          context %(
            <p>
              Feel free to provide any additional information about your ESG practices. If you have already covered your ESG practices in full in this section or section C of the form, just state so.
            </p>
          )
          rows 2
          words_max 200
        end
      end
    end
  end
end
