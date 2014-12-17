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

        textarea :innovation_external_contributors, 'Please name the external organisation(s)/individual(s) that contributed to your innovation, and explain their contribution(s).' do
          ref 'B 4'
          required
          conditional :innovation_any_contributors, :yes
          rows 5
          words_max 500
        end

        textarea :innovation_befits_details, "How does the innovation benefit your customers and your business?" do
          ref 'B 5'
          required
          context %Q{
            <p>e.g. increased efficiency, reduction in costs, design/production/marketing/distribution improvements, better after-sales support, reduced downtime or increased reliability. You can also include testimonials to support your claim. You will have the opportunity to include the financial benefits to your organisation in the next section.</p>
          }
          rows 5
          words_max 800
        end

        textarea :innovation_competitors, "Describe any products/services/initiatives made by others that compete with your innovation, and explain how your innovation differs." do
          ref 'B 6'
          required
          rows 5
          words_max 300
        end

        options :innovations_grant_funding, 'Have you received any grant funding to support your innovation?' do
          ref 'B 7'
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
          ref 'B 8'
          context %Q{
            <p>Please use this box to explain if your innovation was launched by someone else, or any other unusual circumstances.</p>
          }
          max 100
          unit ' years'
          style "small inline"
        end

        textarea :innovation_additional_comments, 'Additional comments (optional)' do
          classes "sub-question"
          rows 5
          words_max 200
        end

        upload :innovation_materials, 'If there is additional material you feel would help us to assess your entry then you can add up to 4 files or links here.' do
          ref 'B 9'
          context %Q{
            <p>We can't guarantee these will be reviewed, so include any vital information within the form.</p>
            <p>You can upload files in all common formats, as long as they're less than 5mb.</p>
            <p>You may link to videos, websites or other media you feel relevant.</p>
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
