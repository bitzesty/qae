class QAE2014Forms
  class << self
    def innovation_step1
      @innovation_step1 ||= Proc.new {
        text :company_name, 'Full/legal name of your business' do
          required
          ref 'A 1'
          help "What name should I write?", %Q{
              <p>Your answer should reflect the title registered with Companies House. If applicable, include 'trading as', or any other name by which the business is known.</p>
          }
        end

        options :principal_business, 'Does your business operate as a principal?' do
          required
          ref 'A 2'
          context %Q{
            <p>We recommend that you apply as a principal. A principal invoices its customers (or their buying agents) and is the body to receive those payments.</p>
          }
          yes_no
        end

        textarea :invoicing_unit_relations,
          'Please explain the arrangements made, and your relationship with the invoicing unit.' do
          required
          conditional :principal_business, :no
          words_max 100
          rows 5
        end

        number :registration_number, 'Company/Charity Registration Number' do
          required
          ref 'A 3'
          help 'What if I do not have a Company/Charity Registration number?', %Q{
            <p>Please enter 'N/A' if this is not applicable. If an unregistered subsidiary, please enter your parent company's number.</p>
          }
        end

        date :started_trading, 'Date started trading' do
          required
          ref 'A 4'
          context '<p>Businesses which began trading after 01/10/2012 are not eligible for this award.</p>'
        end

        options :queen_award_holder, %Q{Are you a current Queen's Award holder (2010-2014)?} do
          required
          ref 'A 5'
          yes_no
        end

        award_holder :queen_award_holder_details, "List the Queen's Award(s) you currently hold" do
          ref 'A 5.1'

          conditional :queen_award_holder, :yes

          category :innovation, 'Innovation'
          category :international_trade, 'International Trade'
          category :sustainable_development, 'Sustainable Development'

          year 2010
          year 2011
          year 2012
          year 2013
          year 2014
        end

        options :business_name_changed, 'Has the name of your business changed since your previous entry?' do
          ref 'A 5.2'

          conditional :queen_award_holder, :yes

          yes_no
        end

        previous_name :previous_business_name, '' do
          conditional :business_name_changed, :yes
        end

        options :other_awards_won, 'Have you won any other business or enterprise awards in the past?' do
          ref 'A 6'
          yes_no
        end

        textarea :other_awards_desc, 'Please describe them' do
          context '<p>Only enter the awards you consider most notable.</p>'
          conditional :other_awards_won, :yes
          rows 5
          words_max 300
        end

        options :joint_entry, 'Is this entry made jointly with any other organisation(s)?' do
          ref 'A 7'
          required
          help "Should my entry be a joint entry?", %Q{
            <p>If the business producing or marketing a product, providing a service or using a technology is separate from the unit which developed it, either or both may be eligible according to the contribution made, and whether it helped them achieve commercial success. For a joint entry, each organisation should submit separate, cross-referenced, entry forms.</p>
          }
          yes_no
        end

        text :joint_entry_names, 'Please enter their name(s)' do
          required
          conditional :joint_entry, :yes
          style :largest
        end

        address :principal_address, 'Principal address of your business' do
          required
          ref 'A 8'
        end

        text :website_url, 'Website URL' do
          required
          ref 'A 9'
          type :url
        end

        dropdown :business_sector, 'Business Sector' do
          required
          ref 'A 10'
          option '', ''
          option :other, 'Other'
        end

        text :business_sector_other, 'Please specify' do
          required
          conditional :business_sector, :other
        end

        head_of_business :head_of_business, 'Head of your business' do
          required
          ref 'A 11'
        end

        text :head_job_title, 'Job title / Role in the organisation' do
          required
          ref 'A 11.1'
        end

        text :head_email, 'Email address' do
          required
          ref 'A 11.2'
          type :email
        end

        options :is_division, 'Are you a division, branch or subsidiary?' do
          ref 'A 12'
          yes_no
        end

        text :parent_company, 'Name of immediate parent company' do
          conditional :is_division, :yes
        end

        dropdown :parent_company_country, 'Country of immediate parent company' do
          conditional :is_division, :yes
          QAE2014Forms.countries.each do |country|
            option country, country
          end
        end

        options :parent_ultimate_control, 'Does the immediate parent company have ultimate control?' do
          ref 'A 12.1'
          conditional :is_division, :yes
          yes_no
        end

        text :ultimate_control_company, 'Name of organisation with ultimate control' do
          conditional :parent_ultimate_control, :no
        end

        dropdown :ultimate_control__company_country, 'Country of organisation with ultimate control' do
          conditional :parent_ultimate_control, :no
          QAE2014Forms.countries.each do |country|
            option country, country
          end
        end

        upload :org_chart, 'Upload an organisational chart (optional).' do
          ref 'A 12.2'
          context %Q{
            <p>It must be one file of less than 5MB, in either MS Word Document, PDF or JPG formats.</p>
          }
          conditional :is_division, :yes
        end
      }
    end
  end
end
