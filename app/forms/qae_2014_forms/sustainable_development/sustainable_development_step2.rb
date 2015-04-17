# -*- coding: utf-8 -*-
class QAE2014Forms
  class << self
    def development_step2
      @development_step2 ||= proc do
        context %(
          <p>Please try to avoid using technical jargon in this section.</p>
                )

        options :my_entry_relates_to, "This entry relates to:" do
          ref "B 1"
          required
          option "product service", "A product/service"
          option "management approach", "A management approach"
          option "both", "Both of the above"
        end

        textarea :development_desc_short, "Briefly describe your product/service/management approach" do
          ref "B 2"
          required
          context %(
            <p>e.g. Arts Company:  “Sustainable print marketing for arts and tourism”; Energy Company:  “Management and delivery of commercial and domestic projects to tackle fuel poverty, energy efficiency and carbon reduction”.</p>
                    )
          rows 2
          words_max 15
        end

        textarea :development_desc_long, "Summarise your product/service/management approach" do
          ref "B 3"
          required
          context %(
            <p>Include a brief description of its origin and development.</p>
                    )
          rows 5
          words_max 500
        end

        textarea :development_approach, "Describe how you manage the resources and/or relationships important to your product/service/management approach." do
          ref "B 4"
          required
          context %(
            <p>Please provide details of any plans, policies, strategies, etc. that you have in place to guide resource and relationship management. Please identify the roles, teams, departments, etc. responsible for the management of resources and/or relationships and how they achieve successful, sustainable management of these.</p>
                    )
          rows 5
          words_max 500
        end

        header :provide_evidence_header, "Where possible, provide evidence of your product/service/management approach's contribution to each of the dimensions of sustainable development below. If your contribution is weak in any of them, describe the relevant actions taken to improve this." do
          ref "B 5"
        end

        textarea :environmental_contribution, "Explain how it contributes to environmental dimensions of sustainable development." do
          required
          classes "sub-question"
          context %(
            <p>
              'Environmental dimensions' means respecting the limits of the planet’s environment, resources and biodiversity
              <a href="#hidden-hint-0" class="hidden-link-for">
                e.g. resources, efficiency, waste reduction and biological diversity/productivity.
              </a>
            </p>
          )
          hint "", %(
            <h3>
              Resources
            </h3>
            <p>
              e.g. reducing use of fossil fuels, metals, aggregates and minerals, increasing use of renewable and recycled materials, generating or using renewable energy.
            </p>

            <h3>
              Efficiency
            </h3>
            <p>
              e.g. using materials (including water) and energy efficiently.
            </p>

            <h3>
              Wastes, emissions and pollution
            </h3>
            <p>
              e.g. reducing waste, reducing omissions of greenhouse gasesm ozone-depleters, toxic and radioactive substances, and persitent synthetics.
            </p>

            <h3>
              Biological diversity and productivity
            </h3>
            <p>
              e.g. protesting and enhancing native species and habitats, increasing use of sustainably managed sources.
            </p>
          )
          rows 5
          words_max 750
        end

        textarea :social_contribution, "Explain how it contributes to social dimensions of sustainable development." do
          classes "sub-question"
          required
          context %(
            <p>
              'Social dimensions' means towards the needs of people in present and future communities, promoting wellbeing, cohesion and equal opportunities
              <a href="#hidden-hint-0" class="hidden-link-for">
                e.g. health and safety, lifelong learning, and building strong communities.
              </a>
            </p>
          )
          hint "", %(
            <h3>
              Health, safety and support
            </h3>
            <p>
              e.g. promoting health and safety in (global) supply chains, promoting skills support and activities to encourage healthy living, promoting access to work and services for people with special needs, contributing to local environment and infrastructure to improve safety and provide opportunities to be healthy.
            </p>

            <h3>
              Social skills, participation and life-long learning
            </h3>
            <p>
              e.g. encouraging people to be involved in sharing views and ideas and making decisions, promoting participation and employee development, increasing opportunities to learn critical skills, helping people to continue learning in their work and personal lives.
            </p>

            <h3>
              Building strong communities
            </h3>
            <p>
              e.g working in partnership with local communities, supporting community activity and volunteering, helping to reduce prejudice and promote understanding, sharing resources with community, voluntary, educational or charitable groups.
            </p>
          )
          rows 5
          words_max 750
        end

        textarea :economic_contribution, "Explain how it contributes to economic dimensions of sustainable development." do
          classes "sub-question"
          required
          context %(
            <p>
              'Economic dimensions' means building a fair, sustainable economy which provides prosperity and opportunity for all
              <a href="#hidden-hint-0" class="hidden-link-for">
                e.g. productivity, socially useful activity, supporting local economies, considering sustainability when making financial and purchasing decisions.
              </a>
            </p>
          )
          hint "", %(
            <h3>
              Work, productive and socially useful activity
            </h3>
            <p>
              e.g. creating jobs, helping people (long-term unemployed, disabled) who might otherwise be without work to contribute to society, and realise their potential.
            </p>

            <h3>
              Finance and sustainable economy
            </h3>
            <p>
              e.g. contributing to prosperity of wider local, regional and national economy, considering environmental and social impact when considering internal financial management systems and financial services bought, using purchase power to support local economy and organisations which are contributing to sustainable development.
            </p>
          )
          rows 5
          words_max 750
        end

        textarea :leadership_contribution, "Explain how it contributes to leadership dimensions of sustainable development." do
          classes "sub-question"
          required
          context %(
            <p>
              'Leadership dimensions' means actively promoting effective, participative systems of governance in all levels of society
              <a href="#hidden-hint-0" class="hidden-link-for">
                e.g. promotion of sustainable development, increasing access to information, management innovation, ethical conduct.
              </a>
            </p>
          )
          hint "", %(
            <h3>
              Trust, access to formation, good governance and stakeholder relations
            </h3>
            <p>
              e.g. improving flow of information to stakeholders, consulting with stakeholders to inform decisions, conducting ethical business and actively opposing corruption and unfair practices.
            </p>

            <h3>
              Promotion of sustainable development
            </h3>
            <p>
              e.g. using indicators, targets, policies and management processes that integrate business practices with sustainable development. Promoting sustainable development:
            </p>
            <ul>
              <li>
                to employees
              </li>
              <li>
                through the supply chain
              </li>
              <li>
                within the business sector
              </li>
              <li>
                to local communities and to other stakeholders
              </li>
              <li>
                in internional operations
              </li>
            </ul>

            <h3>
              Taking part in:
            </h3>
            <ul>
              <li>
                demonstration and pilot projects
              </li>
              <li>
                accredited and verified schemes
              </li>
              <li>
                benchmarking
              </li>
              <li>
                business sector initiatives
              </li>
              <li>
                local initiatives
              </li>
            </ul>

            <h3>
              Management innovation
            </h3>
            <p>
              e.g. including sustainable development in organisation's missions and values, having process to address dilemmas and constraints on action in place, developing innovative ways to engage employees, local communities and stakeholders in sustainable development, developing ways to enhance the organisation's reputation by engaging with sustainable development, developing reawrds for employees with good environmental and social performance.
            </p>
          )
          rows 5
          words_max 750
        end

        textarea :sector_leader_desc, "Describe how you demonstrate sector-leading sustainability performance." do
          ref "B 6"
          required
          context %(
            <p>This can include describing how you benchmark your performance against others in your sector.</p>
                    )
          rows 5
          words_max 750
        end

        textarea :name_of_external_organization_or_individual, "Please name the external organisation(s)/individual(s) that contributed to your product/service/management approach, and explain their contributions." do
          ref "B 7"
          required
          rows 5
          words_max 500
          conditional :external_contribute_to_sustainable_product, "yes"
        end

        options :another_org_licensed, "Is the product/service/management approach under license from another organisation?" do
          ref "B 8"
          required
          yes_no
        end

        textarea :licensing_agreement, "Briefly describe the licensing arrangement." do
          classes "sub-question"
          sub_ref "B 8.1"
          required
          rows 5
          words_max 100
          conditional :another_org_licensed, :yes
        end

        options :grant_support, "Have you received any grant funding to support this product/service/management approach?" do
          ref "B 9"
          required
          yes_no
        end

        textarea :grant_details, "Please give details of date(s), source(s) and level(s) of funding." do
          classes "sub-question"
          sub_ref "B 9.1"
          required
          rows 5
          words_max 300
          conditional :grant_support, :yes
        end

        number :innovation_years_by_applicant, "How long has the product/service/management approach been in commercial operation, production or progress?" do
          ref "B 10"
          required
          max 100
          unit " years"
          style "small inline"
        end

        textarea :development_additional_comments, "Additional comments (optional)" do
          classes "sub-question"
          rows 5
          words_max 200
        end
      end
    end
  end
end
