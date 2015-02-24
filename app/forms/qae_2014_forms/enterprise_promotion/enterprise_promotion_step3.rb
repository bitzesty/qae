# -*- coding: utf-8 -*-
class QAE2014Forms
  class << self
    def promotion_step3
      @promotion_step3 ||= proc do
        textarea :reasons_to_nominate, "Explain why you think your nominee deserves this award." do
          ref "C 1"
          required
          context %(
            <p>
              Include details of how they have made a significant contribution in their area of activity whether in public/private and/or voluntary sectors. Give as much detail as possible about what makes your nominee stand out against others.
            </p>
                    )
          rows 3
          words_max 500
        end

        textarea :benefits_from_nominee_service, "Describe the benefits resulting from the nominee’s services to a particular field, group, community or society as a whole. " do
          ref "C 2"
          required
          context %(
            <p>
              What has their impact been? How wide is their influence? What are their achievements? Include details of the length of time involved and quantitative evidence that demonstrate the clear impact of the nominee’s activities.
            </p>
                    )
          rows 3
          words_max 400
        end

        textarea :benefits_to_underrepresented_groups, "Describe any points when the nominee's activities have taken place within challenging circumstances or disadvantaged/deprived communities, or where young people or under-represented groups have particularly benefited." do
          ref "C 3"
          required
          rows 3
          words_max 300
        end

        options :nominee_deservers_lifetime_achievement_award, "Do you think your nominee deserves a Lifetime Achievement Award?" do
          required
          ref "C 4"
          yes_no
          context %(
            <p>
              A Lifetime Achievement Award is a special Enterprise Promotion Award that is given for outstanding, consistent and effective promotion of business enterprise skills and attitudes <u>over at least ten years.</u>
            </p>
                    )
        end

        textarea :reasons_to_nominate_for_lifetime_achievemnt_award, "Explain why they deserve this award." do
          conditional :nominee_deservers_lifetime_achievement_award, :yes
          words_max 300
          rows 3
          classes "sub-question"
        end
      end
    end
  end
end
