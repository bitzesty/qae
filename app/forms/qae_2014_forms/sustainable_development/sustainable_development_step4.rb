class QAE2014Forms
  class << self
    def development_step4
      @development_step4 ||= Proc.new {
        context %Q{
          <p>Please outline the effects of the activities and practices of your business unit under the headings set out below.</p>
        }

        textarea :impact_on_society, "The impact of your business operations on society" do
          ref 'D 1'
          required
          help "What should I include in this box?", %Q{
            <p>What activies do you undertake to foster good relations with local communities? Outline how you evaluate and report on their impact.</p>
            <p>If you have operations in the third world or developing countries, are these conducted with proper regard for the current and future welfare of the people employed there?</p>
          }
          rows 5
          words_max 500
        end

        textarea :impact_on_environment, 'The environmental impact of your business operations' do
          ref 'D 3'
          required
          help "What should I include in this box?", %Q{
            <p>Description of any environmental considerations within your business eg. energy efficiency strategies, recycling policies, emissions reduction policies.</p>
            <p>If, and how, you undertake environmental impact assessments of major projects. </p>
          }
          rows 5
          words_max 500
        end

        textarea :partners_relations, 'Relations with suppliers, partners and contractors' do
          ref 'D 4'
          required
          help "What should I include in this box?", %Q{
            <p>An outline of your selection criteria, if any, with regard to potential suppliers'/partners'/contractors' economic, social and environmental performance.</p>
            <p>Do you encourage best practice or require them to meet your own standards? To what extent are you succeeding?</p>
          }
          rows 5
          words_max 500
        end

        textarea :employees_relations, 'Relations with employees' do
          ref 'D 5'
          required
          help "What should I include in this box?", %Q{
            <p>Do you have a code of conduct and/or employee policies eg. health and safety, training, staff welfare, whistleblowing and equal opportunities?</p>
            <p>Outline any special employment conditions that you offer eg. flexible working, extended maternity pay.</p>
            <p>How you keep your employees engaged eg. communication, assessments, incentives, opportunities for career development.</p>
          }
          rows 5
          words_max 500
        end

        textarea :customers_relations, 'Relations with customers' do
          ref 'D 6'
          required
          help "What should I include in this box?", %Q{
            <p>What proportion of your sales consist of repeat purchases?</p>
            <p>How do you measure customer satisfaction, and what have been the results?</p>
            <p>The criteria by which you select clients and how you ensure they are appropriate for your services.</p>
          }
          rows 5
          words_max 500
        end
      }
    end
  end
end
