class QAE2014Forms
  class << self
    def innovation_step2
      @innovation_step2 ||= proc do
        context %(
          <p>Please try to avoid using technical jargon in this section. </p>
                )

        textarea :innovation_desc_short, "Briefly describe your innovative product/service/initiative" do
          ref "B 1"
          required
          classes "word-max-strict"
          context %(
            <p>e.g. 'innovation in the production of injectable general anaesthetic.'</p>
                    )
          rows 2
          words_max 15
        end

        textarea :innovation_desc_long, "Summarise your innovative product/service/initiative" do
          classes "sub-question"
          sub_ref "B 1.1"
          required
          context %{
            <p>Describe the product/service/initiative itself. Explain any aspect(s) you think are innovative, and why you think they are innovative. Consider its uniqueness and the challenges you had to overcome. Also explain how it fits within the overall business i.e. is it your sole product?</p>
          }
          rows 5
          words_max 800
        end

        textarea :innovation_context, "Describe the market conditions that led to the creation of your innovation." do
          ref "B 2"
          required
          context %(
            <p>Or otherwise, how you identified a gap in the market.</p>
                    )
          rows 5
          words_max 500
        end

        textarea :innovation_overcomes_issues, "Discuss the degree to which your innovation solves prior problems, and any difficulties you overcame in achieving these solutions." do
          ref "B 3"
          required
          rows 5
          words_max 800
        end

        textarea :innovation_external_contributors, "Please name the external organisation(s)/individual(s) that contributed to your innovation, and explain their contribution(s)." do
          ref "B 4"
          required
          conditional :innovation_any_contributors, :yes
          rows 5
          words_max 500
        end

        textarea :innovation_befits_details_business, "How does the innovation benefit your business?" do
          ref "B 5"
          required
          context %(
            <p>
              e.g. increased efficiency, reduction in costs, design / production / marketing / distribution improvements, better after-sales support, reduced downtime or increased reliability. <strong>You will have the opportunity to include more details of the financial benefits to your organisation in the Commercial Performance section of the form</strong>.
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :innovation_befits_details_customers, "Does the innovation benefit your customers and, if so, how?" do
          ref "B 6"
          required
          context %(
            <p>
              e.g. increased efficiency, reduction in costs, design / production / marketing / distribution improvements, better after-sales support, reduced downtime or increased reliability. <strong>Please quantify if possible</strong>. You can also include testimonials to support your claim.
            </p>
          )
          rows 5
          words_max 500
        end

        textarea :innovation_competitors, "Describe any products/services/initiatives made by others that compete with your innovation, and explain how your innovation differs." do
          ref "B 7"
          required
          rows 5
          words_max 300
        end

        options :innovations_grant_funding, "Have you received any grant funding to support your innovation?" do
          ref "B 8"
          required
          yes_no
        end

        textarea :innovation_grant_funding_sources, "Please give details of date(s), source(s) and level(s) of funding." do
          classes "sub-question"
          sub_ref "B 8.1"
          required
          conditional :innovations_grant_funding, :yes
          rows 5
          words_max 300
        end

        number :innovation_years, "How long have you had your innovation on the market?" do
          required
          ref "B 9"
          max 100
          unit " years"
          style "small inline"
        end

        textarea :innovation_additional_comments, "Additional comments (optional)" do
          classes "sub-question"
          sub_ref "B 9.1"
          rows 5
          words_max 200
          context %(
            <p>Please use this box to explain if your innovation was launched by someone else, or any other unusual circumstances.</p>
                    )
        end
      end
    end
  end
end
