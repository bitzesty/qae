class QAE2014Forms
  class << self
    def promotion_step1
      @promotion_step1 ||= Proc.new {
        dropdown :title, 'Title' do
          required
          ref 'A 1'
          option 'prof', 'Prof'
          option 'dr', 'Dr'
          option 'mr', 'Mr'
          option 'mrs', 'Mrs'
          option 'miss', 'Miss'
          option 'other', 'Other'
        end

        text :title_other, 'Please specify' do
          classes "sub-question"
          conditional :title, 'other'
        end

        text :first_name, 'First name' do
          required
        end

        text :last_name, 'Surname' do
          required
        end

        text :former_name, 'Former name, or any other name known by' do
          required
          context "<p>e.g. maiden name</p>"
        end

        address :personal_address, 'Personal address' do
          required
          ref 'A 1.1'
        end

        text :phone, 'Telephone number' do
          required
          ref 'A 1.2'
          style "small"
        end

        text :email, 'Email address' do
          required
          ref 'A 1.3'
        end


        date :date_of_birth, 'Date of birth' do
          required
          ref 'A 1.3'
        end

        options :nationality, 'Nationality' do
          required
          ref 'A 1.4'
          option 'british', 'British'
          option 'other', 'Other'
        end

        text :nationality_other, 'Please specify' do
          classes "sub-question"
          conditional :nationality, 'other'
        end

        options :award_holder, "Does the nominee currently hold any Awards/Honours?" do
          required
          ref 'A 2'
          yes_no
        end

        award_holder :awards, "List of the Awards/Honours nominee currently hold" do
          classes "sub-question"
          year :year, 2010..2014
          details_words_max 50

          conditional :award_holder, :yes
        end

        header :organization_info, 'Organisation for which the nominee works' do
          ref 'A 3'
        end

        text :organization_name, 'Name' do
          required
        end

        address :organization_address, '' do
          required
        end

        text :website, 'Website URL' do
          ref 'A 3.1'
        end

        text :nominee_position, "Nominee's position at the organisation" do
          required
          ref 'A 3.2'
        end
      }
    end
  end
end
