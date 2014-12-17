class QAE2014Forms
  class << self
    def innovation_step2
      @innovation_step2 ||= Proc.new {
        context %Q{
          <p>Please try to avoid using technical jargon in this section. </p>
        }

        textarea :innovation_desc_short, 'Briefly describe your product/service/initiative' do
          ref 'B 1'
          required
          context %Q{
            <p>e.g. 'innovation in the production of injectable general anaesthetic.'</p>
          }
          rows 2
          words_max 15
        end

        textarea :innovation_desc_long, 'Describe your innovative product/service/initiative in detail' do
          classes "sub-question"
          required
          context %Q{
            <p>Describe the product/service/initiative itself. Explain any aspect(s) you think are innovative, and why you think they are innovative. Consider its uniqueness and the challenges you had to overcome. Also explain how it fits within the overall business i.e. is it your sole product?</p>
          }
          rows 5
          words_max 800
        end

        textarea :innovation_context, 'Describe the market conditions that led to the creation of your innovation.' do
          ref 'B 2'
          required
          context %Q{
            <p>Or otherwise, how you identified a gap in the market.</p>
          }
          rows 5
          words_max 500
        end

        textarea :innovation_overcomes_issues, "Discuss the degree to which your innovation solves prior problems, and any difficulties you overcame in achieving these solutions." do
          ref 'B 3'
          required
          rows 5
          words_max 800
        end

        textarea :innovation_befits_details, "How does the innovation benefit your customers and your business?" do
          ref 'B 4'
          required
          context %Q{
            <p>e.g. increased efficiency, reduction in costs, design/production/marketing/distribution improvements, better after-sales support, reduced downtime or increased reliability. You can also include testimonials to support your claim by uploading them in B10.</p>
          }
          rows 5
          words_max 800
        end

        textarea :innovation_competitors, "Describe any products/services/initiatives made by others that compete with your innovation, and explain how your innovation differs." do
          ref 'B 5'
          required
          rows 5
          words_max 300
        end

        options :innovation_any_contributors, 'Did any external organisation or individual contribute to your innovation?' do
          ref 'B 6'
          required
          context %Q{
            <p>Excluding suppliers, consultants and any joint entrant(s) named in A8 above.</p>
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

        options :innovation_under_license, 'Is your innovation under license from another organisation?' do
          ref 'B 7'
          yes_no
        end

        textarea :innovation_license_terms, 'Briefly describe the licensing arrangement.' do
          classes "sub-question"
          required
          conditional :innovation_under_license, :yes
          rows 5
          words_max 100
        end

        options :innovations_grant_funding, 'Have you received any grant funding to support your innovation?' do
          ref 'B 8'
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

        number :innovation_years, 'How long have you had your innovation on the market?' do
          required
          ref 'B 9'
          max 100
          unit ' years'
          style "small inline"
        end

        textarea :innovation_additional_comments, 'Additional comments' do
          classes "sub-question"
          rows 5
          words_max 200
        end

        upload :innovation_materials, 'If there is additional material you feel would help us to assess your entry then you can add up to 4 files or links here.' do
          ref 'B 10'
          context %Q{
            <p>We can't guarantee these will be reviewed, so include any vital information within the form.</p>
            <p>You may upload files of less than 5mb each in either MS Word Document, PDF, MS Excel Spreadsheet or MS Powerpoint Presentation formats. You may link to videos, websites or other media you feel relevant.</p>
            <p>We won't consider business plans, annual accounts or company policy documents. Additional materials should not be used as a substitute for completing sections of the form.</p>
          } # TODO!
          max_attachments 4
          links
          description
        end
      }
    end
  end
end
