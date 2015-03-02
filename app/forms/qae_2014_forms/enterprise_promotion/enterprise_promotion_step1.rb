class QAE2014Forms
  class << self
    def promotion_step1
      @promotion_step1 ||= proc do
        dropdown :nominee_title, "Title" do
          required
          ref "A 1"
          option "prof", "Prof"
          option "dr", "Dr"
          option "mr", "Mr"
          option "mrs", "Mrs"
          option "miss", "Miss"
          option "other", "Other"
        end

        text :nominee_title_other, "Please specify" do
          required
          classes "sub-question"
          conditional :nominee_title, "other"
        end

        text :nominee_first_name, "First name" do
          required
        end

        text :nominee_last_name, "Surname" do
          required
        end

        text :nominee_former_name, "Former name, or any other name known by" do
          required
          context "<p>e.g. maiden name</p>"
        end

        address :nominee_personal_address, "Personal address" do
          required
          ref "A 1.1"
        end

        text :nominee_phone, "Telephone number" do
          required
          ref "A 1.2"
          style "small"
        end

        text :nominee_email, "Email address" do
          required
          ref "A 1.3"
        end

        date :nominee_date_of_birth, "Date of birth" do
          required
          ref "A 1.4"
        end

        options :nominee_nationality, "Nationality" do
          required
          ref "A 1.5"
          option "british", "British"
          option "other", "Other"
        end

        text :nominee_nationality_other, "Please specify" do
          required
          classes "sub-question"
          conditional :nominee_nationality, "other"
        end

        options :award_holder, "Does the nominee currently hold any Awards/Honours?" do
          required
          ref "A 2"
          yes_no
        end

        award_holder :awards, "List of the Awards/Honours nominee currently hold" do
          classes "sub-question"
          year :year, 2010..2014
          details_words_max 50

          conditional :award_holder, :yes
        end

        options :nominated_for_award, "Is the nominee currently being nominated for another award/honor?" do
          required
          ref "A 2.1"
          yes_no
        end

        award_holder :nomination_awards, "List of the Awards/Honours nominee is currently being nominated for" do
          classes "sub-question"
          year :year, 2010..2014
          details_words_max 50

          conditional :nominated_for_award, :yes
        end

        organization_address :organization_address, "Organisation for which the nominee works" do
          required
          ref "A 3"
        end

        text :nominee_position, "Nominee's position at the organisation" do
          required
          ref "A 3.1"
        end
      end
    end
  end
end
