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
          option "both", "Both the above"
        end

        textarea :development_desc_short, "Briefly describe your product/service/management approach" do
          ref "B 2"
          required
          context %(
            <p>eg. Arts Company:  “Sustainable print marketing for arts and tourism”; Energy Company:  “Management and delivery of commercial and domestic projects to tackle fuel poverty, energy efficiency and carbon reduction”.</p>
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

        textarea :environmental_contribution, "Explain how your approach contributes to environmental dimensions of sustainable development." do
          required
          classes "sub-question"
          context %(
            <p>'Environmental dimensions' means respecting the limits of the planet’s environment, resources and biodiversity e.g. resource efficiency, waste reduction and biological diversity/productivity.</p>
                    )
          rows 5
          words_max 750
        end

        textarea :social_contribution, "Explain how your approach contributes to social dimensions of sustainable development." do
          classes "sub-question"
          required
          context %(
            <p>'Social dimensions' means towards the needs of people in present and future communities, promoting wellbeing, cohesion and equal opportunities e.g. health and safety, lifelong learning, and building strong communities.</p>
                    )
          rows 5
          words_max 750
        end

        textarea :economic_contribution, "Explain how your approach contributes to economic dimensions of sustainable development." do
          classes "sub-question"
          required
          context %{
            <p>'Economic dimensions' means building a fair, sustainable economy which provides prosperity and opportunity for all e.g. productivity, socially useful activity (eg. assisting the long term unemployed into work), supporting local economies.</p>
          }
          rows 5
          words_max 750
        end

        textarea :leadership_contribution, "Explain how your approach contributes to leadership dimensions of sustainable development." do
          classes "sub-question"
          required
          context %(
            <p>'Leadership dimensions' means actively promoting effective, participative systems of governance in all levels of society e.g. promotion of sustainable development, increasing access to information, management innovation, ethical conduct.</p>
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

        options :you_released_product, "Was the product/service/management approach released by you?" do
          classes "sub-question"
          required
          yes_no
        end

        number :product_age, "How many years have you had it in the marketplace?" do
          classes "regular-question inline-input-question"
          required
          max 100
          unit " years"
          style "small inline"
          conditional :you_released_product, :no
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
