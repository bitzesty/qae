class QAE2014Forms
  class << self
    def trade_step1
      @trade_step1 ||= Proc.new {
        # TODO Pre-filled from registration details
        text :company_name, 'Full/legal name of your organisational unit' do
          required
          ref 'A 1'
          help "What name should I write?", %Q{
              <p>Your answer should reflect the title registered with Companies House. If applicable, include 'trading as', or any other name by which the business is known.</p>
          }
        end

        options :principal_business, 'Does your unit operate as a principal?' do
          required
          ref 'A 2'
          context %Q{
            <p>We recommend that you apply as a principal. A principal invoices its customers (or their buying agents) and is the body to receive those payments.</p>
          }
          yes_no
        end

        textarea :invoicing_unit_relations,
          'Please explain the arrangements made, and your relationship with the invoicing unit.' do
          classes "sub-question"
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
          style "small"
        end

        date :started_trading, 'Date started trading' do
          required
          ref 'A 4'
          context '<p>Businesses which began trading after 01/10/2012 are not eligible for this award.</p>'
          date_max '01/10/2012'
        end

        options :queen_award_holder, %Q{Are you a current Queen's Award holder (2010-2014)?} do
          required
          ref 'A 5'
          yes_no
        end

        award_holder :queen_award_holder_details, "List the Queen's Award(s) you currently hold" do
          classes "sub-question"

          conditional :queen_award_holder, :yes

          category :innovation_2, 'Innovation (2 years)'
          category :innovation_5, 'Innovation (5 years)'
          category :international_trade_3, 'International Trade (3 years)'
          category :international_trade_6, 'International Trade (6 years)'
          category :sustainable_development_2, 'Sustainable Development (2 years)'
          category :sustainable_development_5, 'Sustainable Development (5 years)'

          year 2010
          year 2011
          year 2012
          year 2013
          year 2014
        end

        options :business_name_changed, 'Has the name of your organisation changed since your previous entry?' do
          classes "sub-question"

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
          classes "sub-question"
          context '<p>Only enter the awards you consider most notable.</p>'
          conditional :other_awards_won, :yes
          rows 5
          words_max 300
        end

        options :joint_entry, 'Is this entry made jointly with any other organisation(s)?' do
          ref 'A 7'
          required
          help "Should my entry be a joint entry?", %Q{
            <p>Joint entires can be submitted if two (or more) companies developed the innovation and realised commercial success. Each organisation should submit separate, cross-referenced, entry forms. For more information, see the FAQ.</p>
          }
          yes_no
        end

        text :joint_entry_names, 'Please enter their name(s)' do
          classes "sub-question"
          required
          conditional :joint_entry, :yes
          style "largest"
        end

        # Prefilled from registration details
        address :principal_address, 'Principal address of your organisational unit' do
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
          option '', 'Business Sector'
          option :other, 'Other'
        end

        text :business_sector_other, 'Please specify' do
          classes "regular-question"
          required
          conditional :business_sector, :other
        end

        head_of_business :head_of_business, 'Head of your organisational unit' do
          required
          ref 'A 11'
        end

        text :head_job_title, 'Job title / Role in the organisation' do
          classes "sub-question"
          required
        end

        text :head_email, 'Email address' do
          classes "sub-question"
          required
          type :email
        end

        options :is_division, 'Are you a division, branch or subsidiary?' do
          ref 'A 12'
          yes_no
        end

        text :parent_company, 'Name of immediate parent company' do
          classes "regular-question"
          conditional :is_division, :yes
        end

        country :parent_company_country, 'Country of immediate parent company' do
          classes "regular-question"
          conditional :is_division, :yes
        end

        options :parent_ultimate_control, 'Does the immediate parent company have ultimate control?' do
          classes "sub-question"
          conditional :is_division, :yes
          yes_no
        end

        text :ultimate_control_company, 'Name of organisation with ultimate control' do
          classes "regular-question"
          conditional :parent_ultimate_control, :no
        end

        country :ultimate_control_company_country, 'Country of organisation with ultimate control' do
          classes "regular-question"
          conditional :parent_ultimate_control, :no
        end

        options :trading_figures, 'Do you have any UK subsidiaries, associates or plants whose trading figures are included in this entry?' do
          ref 'A 13'
          required
          yes_no
        end

        subsidiaries_associates_plants :trading_figures_add, '' do
          required
          conditional :trading_figures, :yes
        end

        textarea :excluded_explanation, 'Parent companies making group entries should include figures for all UK subsidiaries. If any part of the group is excluded, please provide an explanation here.' do
          classes "sub-question"
          rows 5
          words_max 200
        end

        options :export_agent, 'Are you an export agent/merchant?' do
          ref 'A 14'
          required
          yes_no
          help 'What is an export agent?', %Q{
            <p>An export agent is an individual or company that undertakes export activity on behalf of another company in return for payment by means of a commission.</p>
          }
          help 'What is an export merchant?', %Q{
            <p>An export merchant buys and takes ownership of merchandise to generate income by selling at a higher price. An export merchant may rebrand or repack goods before selling them on.</p>
          }
        end

        options :export_unit, 'Are you an export unit?' do
          ref 'A 15'
          required
          yes_no
          help 'What is an export unit?', %Q{
            <p>An export unit is a subsidiary or operating unit of a larger company that manages the company's export activities. </p>
          }
        end

        upload :org_chart, 'Upload an organisational chart.' do
          ref 'A 16'
          context %Q{
            <p>It must be one file of less than 5MB, in either MS Word Document, PDF or JPG formats.</p>
          }
        end
      }
    end
  end
end
