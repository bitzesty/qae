class QAE2014Forms
  class << self
    def trade_step4
      @trade_step4 ||= Proc.new {
        options :corp_responsibility_form, 'You may complete the full corporate responsibility form now, or make a declaration now and complete the form in the event of you being shortlisted.' do
          ref 'D 1'
          required
          context %Q{
            <p>This decision doesn't affect your chance of success.</p>
          }
          option :complete_now, 'Complete full corporate responsibility form now'
          option :declare_now, 'Complete declaration now, and full form once shortlisted'
        end

        header :complete_now_header, "" do
          context %Q{
            <p>The Declaration of Corporate Responsibility is a chance for you to outline your responsible business conduct, and its social, economic and environmental impact.</p>
            <p>You don't have to demonstrate strength in all of the areas below.</p>
            <p>If you have too many initiatives, just outline the ones you think are most relevant/important.</p>
          }
        end

        textarea :impact_on_society, "The impact of your business operations on society" do
          ref 'D 2'
          required
          context %Q{
            <p>What activities do you undertake to foster good relations with local communities? Outline how you evaluate and report on their impact.</p>
            <p>If you have operations in the third world or developing countries, are these conducted with proper regard for the current and future welfare of the people employed there?</p>
          }
          rows 5
          words_max 500
        end

        textarea :impact_on_environment, 'The environmental impact of your business operations' do
          ref 'D 3'
          required
          conditional :corp_responsibility_form, :complete_now
          context %Q{
            <p>Description of any environmental considerations within your business e.g. energy efficiency strategies, recycling policies, emissions reduction policies.</p>
            <p>If, and how, you undertake environmental impact assessments of major projects.</p>
          }
          rows 5
          words_max 500
        end

        textarea :partners_relations, 'Relations with suppliers, partners and contractors' do
          ref 'D 4'
          required
          conditional :corp_responsibility_form, :complete_now
          context %Q{
            <p>An outline of your selection criteria, if any, with regard to potential suppliers'/partners'/contractors' economic, social and environmental performance.</p>
            <p>Do you encourage best practice or require them to meet your own standards? To what extent are you succeeding?</p>
          }
          rows 5
          words_max 500 
        end

        textarea :employees_relations, 'Relations with employees' do
          ref 'D 5'
          required
          conditional :corp_responsibility_form, :complete_now
          context %Q{
            <p>Do you have a code of conduct and/or employee policies e.g. health and safety, training, staff welfare, whistleblowing and equal opportunities?</p>
            <p>Outline any special employment conditions that you offer e.g. flexible working, extended maternity pay.</p>
            <p>How you keep your employees engaged e.g. communication, assessments, incentives, opportunities for career development.</p>
          }
          rows 5
          words_max 500 
        end

        textarea :customers_relations, 'Relations with customers' do
          ref 'D 6'
          required
          conditional :corp_responsibility_form, :complete_now
          context %Q{
            <p>What proportion of your sales consist of repeat purchases?</p>
            <p>How do you measure customer satisfaction, and what have been the results?</p>
            <p>The criteria by which you select clients and how you ensure they are appropriate for your services.</p>
          }
          rows 5
          words_max 500 
        end

        confirm :declaration_of_corporate_responsibility, '' do
          required
          text 'I declare corporate responsibility lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.<br><br>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
          conditional :corp_responsibility_form, :declare_now
        end
      }
    end
  end
end
