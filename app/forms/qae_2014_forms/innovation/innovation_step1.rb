class QAE2014Forms
  class << self
    def innovation_step1
      @innovation_step1 ||= Proc.new {
        options :applying_for, "Are you applying on behalf of your:" do
          ref 'A 1'
          option 'organisation', 'Whole organisation'
          option 'division branch subsidiary', 'A division, branch or subsidiary'
        end

        # TODO Pre-filled from registration details
        text :company_name, 'Full/legal name of your organisation' do
          required
          ref 'A 2'
          context %Q{
            <p>This should reflect the title registered with Companies House. If applicable, include 'trading as', or any other name your organisation uses.</p>
          }
        end

        options :principal_business, 'Does your organisation operate as a principal?' do
          required
          ref 'A 3'
          context %Q{
            <p>We recommend that you apply as a principal. A principal invoices its customers (or their buying agents) and is the body to receive those payments.</p>
          }
          yes_no
        end

        textarea :invoicing_unit_relations, 'Please explain your relationship with the invoicing unit, and the arrangements made.' do
          classes "sub-question"
          required
          conditional :principal_business, :no
          words_max 200
          rows 5
        end

        number :registration_number, 'Company/Charity Registration Number' do
          required
          ref 'A 4'
          context %Q{
            <p>If you don't have a Company/Charity Registration Number please enter 'N/A'. If you're an unregistered subsidiary, please enter your parent company's number.</p>
          }
          style "small"
        end

        date :started_trading, 'Date started trading' do
          required
          ref 'A 5'
          context "<p>Organisations that began trading after 01/10/2012 aren't eligible for this award.</p>"
          date_max '01/10/2012'
        end

        options :queen_award_holder, "Are you a current Queen's Award holder (2010-2014)?" do
          required
          ref 'A 6'
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

        options :business_name_changed, 'Have you changed the name of your organisation since your last entry?' do
          classes "sub-question"

          conditional :queen_award_holder, :yes

          yes_no
        end

        text :previous_business_name, 'Name used previously' do
          classes "regular-question"
          required
          conditional :business_name_changed, :yes
        end

        textarea :previous_business_ref_num, 'Reference number used previously' do
          classes "regular-question"
          required
          conditional :business_name_changed, :yes
          rows 5
          words_max 100
        end

        options :other_awards_won, 'Have you won any other business awards in the past?' do
          ref 'A 7'
          yes_no
        end

        textarea :other_awards_desc, 'Please describe them' do
          classes "sub-question"
          context "<p>If you can't fit all of your awards below, then choose those you're most proud of.</p>"
          conditional :other_awards_won, :yes
          rows 5
          words_max 300
        end

        options :joint_entry, 'Is this entry made jointly with any other organisation(s)?' do
          ref 'A 8'
          required
          context %Q{
            <p>If the business producing or marketing a product, providing a service or using a technology is separate from the unit which developed it, either or both may be eligible for an award.</p><p>If you both made a significant contribution to the innovation, and both achieved commercial success, then you should make a joint entry. Each organisation should submit separate, cross-referenced, entry forms.</p>
          }
          yes_no
        end

        textarea :joint_entry_names, 'Please enter their name(s)' do
          classes "sub-question"
          required
          conditional :joint_entry, :yes
          rows 5
          words_max 100
        end

        # Prefilled from registration details
        address :principal_address, 'Principal address of your organisation' do
          required
          ref 'A 9'
        end

        text :website_url, 'Website URL' do
          required
          ref 'A 10'
        end

        dropdown :business_sector, 'Business Sector' do
          required
          ref 'A 11'
          option '', 'Business Sector'
          option :other, 'Other'
        end

        text :business_sector_other, 'Please specify' do
          classes "regular-question"
          required
          conditional :business_sector, :other
        end

        head_of_business :head_of_business, 'Head of your organisation' do
          required
          ref 'A 12'
        end

        text :head_job_title, 'Job title / Role in the organisation' do
          classes "sub-question"
          required
          context %Q{
            <p>e.g. CEO, Managing Director, Founder</p>
          }
        end

        text :head_email, 'Email address' do
          classes "sub-question"
          required
        end

        header :parent_company_header, 'Parent Companies' do
          ref 'A 13'
          conditional :applying_for, 'division branch subsidiary'
        end

        text :parent_company, 'Name of immediate parent company' do
          classes "sub-question"
          conditional :applying_for, 'division branch subsidiary'
        end

        country :parent_company_country, 'Country of immediate parent company' do
          classes "regular-question"
          conditional :applying_for, 'division branch subsidiary'
        end

        options :parent_ultimate_control, 'Does your immediate parent company have ultimate control?' do
          classes "sub-question"
          conditional :applying_for, 'division branch subsidiary'
          yes_no
        end

        text :ultimate_control_company, 'Name of organisation with ultimate control' do
          classes "regular-question"
          conditional :parent_ultimate_control, :no
          conditional :applying_for, 'division branch subsidiary'
        end

        country :ultimate_control__company_country, 'Country of organisation with ultimate control' do
          classes "regular-question"
          conditional :parent_ultimate_control, :no
          conditional :applying_for, 'division branch subsidiary'
        end

        upload :org_chart, 'Upload an organisational chart (optional).' do
          ref 'A 14'
          context %Q{
            <p>It should be less than 5MB, and in either MS Word Document, PDF or JPG formats.</p>
          }
          max_attachments 1
        end
      }
    end
  end
end
