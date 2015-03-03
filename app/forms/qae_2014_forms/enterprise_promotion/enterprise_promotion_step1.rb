class QAE2014Forms
  class << self
    def promotion_step1
      @promotion_step1 ||= proc do
        header :nominee_header, "Nominee" do
          ref "A 1"
        end

        dropdown :nominee_title, "" do
          required
          context %(
            <p class='question_label_with_5px_margins'>Title</p>
                    )
          option "prof", "Prof"
          option "dr", "Dr"
          option "mr", "Mr"
          option "mrs", "Mrs"
          option "miss", "Miss"
          option "other", "Other"
        end

        text :nominee_title_other, "" do
          required
          classes "sub-question"
          context %(
            <p class='question_label_with_5px_margins'>Please specify</p>
                    )
          conditional :nominee_title, "other"
        end

        user_info :nominee_info, "" do
          required
          sub_fields([
            {first_name: "First name"},
            {last_name: "Surname"},
            {former_name: "Former name, or any other name known by (e.g. maiden name)"}
          ])
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

        address :organization_address, "Organisation for which the nominee works" do
          required
          ref "A 3"
          sub_fields([
            {name: "Name"},
            {building: "Building"},
            {street: "Street"},
            {city: "Town or city"},
            {country: "Country"},
            {postcode: "Postcode"},
            {website_url: "Website URL"}
          ])
        end

        text :nominee_position, "Nominee's position at the organisation" do
          required
          ref "A 3.1"
        end
      end
    end
  end
end
