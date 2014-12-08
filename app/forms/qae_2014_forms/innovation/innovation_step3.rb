class QAE2014Forms
  class << self
    def innovation_step3
      @innovation_step3 ||= Proc.new {
        context %Q{
          <p>When answering these questions please avoid using technical jargon where possible. If you have more than one innovative product/service you will need to submit more than one application.</p>
        }

        textarea :innovation_desc_short, 'Briefly describe your product/service/intiative' do
          ref 'C 1'
          required
          context %Q{
            <p>e.g. 'innovation in the production of injectable general anaesthetic.'</p>
          }
          rows 1
          words_max 15
        end

        textarea :innovation_desc_long, 'Describe your innovative product/service/initiative in detail' do
          classes "sub-question"
          required
          context %Q{
            <p>Describe the product/service/intitative itself, explain any aspect(s) you believe innovative, and why you believe it is innovative: consider its uniqeueness and the challenges you had to overcome. Also explain how it fits within the overall business e.g. is it your sole product.</p>
          }
          rows 5
          words_max 800
        end

        textarea :innovation_context, 'Describe the context of your innovation, why and how it came about.' do
          ref 'C 2'
          required
          context %Q{
            <p>Outline the disadvantages, if any, of your own/competing products/services/intiatives prior to the innovation. Or otherwise, how you identified a gap in the market.</p>
          }
          rows 5
          words_max 500
        end

        textarea :innovation_overcomes_issues, "Discuss the degree to which your innovation overcomes any issues, and any special difficulties surmounted in doing so." do
          ref 'C 3'
          required
          rows 5
          words_max 800
        end

        textarea :innovation_befits_details, "Give details of benefits received by your customers and your business as a result of the innovation." do
          ref 'C 4'
          required
          context %Q{
            <p>e.g. increased efficiency, reduction in costs, design/production/marketing/distribution improvements, better after-sales support, reduced downtime or increased reliability. You can also include testimonials to support your claim.</p>
          }
          rows 5
          words_max 800
        end

        textarea :innovation_competitors, "Identify and describe any products/services/initiatives made by other organisations that compete with your innovation, and explain how your innovation differs." do
          ref 'C 5'
          required
          rows 5
          words_max 300
        end

        options :innovation_any_contributors, 'Did any external organisation or individiual contribute to this product/service/initiative?' do
          ref 'C 6'
          required
          context %Q{
            <p>Excluding any joint entrant(s) named in C5.</p>
          }
          yes_no
        end

        textarea :innovation_contributors, 'Please enter their name(s) and explain their contribution(s).' do
          classes "sub-question"
          required
          conditional :innovation_any_contributors, :yes
          rows 5
          words_max 500
        end

        options :innovation_contributors_aware, 'Are they aware that you are applying for this award?' do
          classes "sub-question"
          required
          conditional :innovation_any_contributors, :yes
          yes_no
          option :some, 'Some are aware'
        end

        options :innovation_under_license, 'Is the product/service/initiative under license from another organisation?' do
          ref 'C 7'
          yes_no
        end

        textarea :innovation_license_terms, 'Briefly describe the licensing arrangement.' do
          classes "sub-question"
          required
          conditional :innovation_under_license, :yes
          rows 5
          words_max 100
        end

        options :innovations_grant_funding, 'Have you received any grant funding to support this innovation?' do
          ref 'C 8'
          required
          yes_no
        end

        textarea :innovation_grant_funding_sources, "Please give details of date(s), source(s) and level(s) of funding." do
          classes "sub-question"
          required
          conditional :innovations_grant_funding, :yes
          rows 5
          words_max 300
        end

        number :innovation_years, 'How long has it been since the product/service/initiative was released into the marketplace?' do
          required
          ref 'C 9'
          max 100
          unit ' years'
          style "small inline"
        end

        options :innovation_released_by_applicant, "Was the product/service/intiative released by you?" do
          classes "sub-question"
          required
          yes_no
        end

        number :innovation_years_by_applicant, 'How many years have you had it in the marketplace?' do
          classes "regular-question inline-input-question"
          required
          conditional :innovation_released_by_applicant, :no
          max 100
          unit ' years'
          style "small inline"
        end

        textarea :innovation_additional_comments, 'Additional comments (optional)' do
          classes "sub-question"
          rows 5
          words_max 200
        end

        materials :innovation_materials, 'If there is additional material you feel would help us to assess your entry then you can add up to 4 files or links here.' do
          ref 'C 10'
          context %Q{
            <p>We cannot guarantee these will be reviewed, so inlcude any vital information within the form.</p>
            <p>You may upload files of less than 5mb each in either MS Word Document, PDF, MS Excel Spreadsheet or MS Powerpoint Presentation formats. Or MP4 (video) files of up to TODOmb</p>
          } # TODO!
          help 'Information we will not review', %Q{
            <p>We will not consider business plans, annual accounts or company policy documents. Additional materials should not be used as a substitue for completing sections of the form.</p>
          }
        end
      }
    end
  end
end
