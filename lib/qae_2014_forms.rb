require 'qae_form_builder'

class QAE2014Forms
  class << self

  def innovation
    @innovation ||= QAEFormBuilder.build 'Apply for the innovation award' do

      step "Company Information" do

        text :company_name, 'Full/legal name of your business' do
          required
          ref 'A1'
          help "What name should I write?",  %Q{
              <p>Your answer should reflect the title registered with Companies House.
              If applicable, include 'trading as', or any other name by which the
              business is known.</p>
          }
        end

        options :principal_business, 'Does your business operate as a principal?' do
          required
          ref 'A2'
          context %Q{
            <p>We recommend that you apply as a principal. A principal invoices its
            customers (or their buying agents) and is the body to receive those payments.</p>
          }
          option :yes, 'Yes'
          option :no, 'No'
        end

      end

    end
  end

  end
end
