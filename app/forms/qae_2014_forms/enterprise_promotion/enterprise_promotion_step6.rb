# -*- coding: utf-8 -*-
class QAE2014Forms
  class << self
    def promotion_step6
      @promotion_step6 ||= proc do
        header :user_info_header, "Your full name" do
          ref "F 1"
        end

        dropdown :user_info_title, "Title" do
          required
          classes "regular-question"
          option "prof", "Prof"
          option "dr", "Dr"
          option "mr", "Mr"
          option "mrs", "Mrs"
          option "miss", "Miss"
          option "other", "Other"
        end

        text :user_info_title_other, "Please specify" do
          classes "regular-question"
          conditional :user_info_title, "other"
        end

        user_info :user_info, "" do
          required
          sub_fields([
            { first_name: "First name" },
            { last_name: "Surname" }
          ])
        end

        address :personal_address, "Your personal address" do
          required
        end

        text :personal_phone, "Telephone number" do
          required
          style "small"
        end

        text :personal_email, "Email address" do
          required
        end

        text :relationship_to_nominee, "Your relationship to the nominee" do
          required
        end

        header :confirmation_of_contact_header, "Confirmation of contact" do
          ref "F 2"
        end

        confirm :agree_being_contacted_about_issues_not_related_to_application, "" do
          text "I am happy to be contacted about Queen's Award for Enterprise issues not related to my application (e.g. acting as a case study, newsletters, other info)."
        end

        confirm :agree_being_contacted_by_department_of_business, "" do
          text "I am happy to be contacted by the Department of Business, Innovation and Skills."
        end

        header :confirmation_of_entry_header, "Confirmation of entry" do
          ref "F 3"
        end

        confirm :entry_confirmation, "" do
          required
          text %(
            By ticking this box, I submit a nomination for consideration for the Queen’s Award for Enterprise Promotion 2015. I certify that all the particulars given, and those in any accompanying statements are correct to the best of my knowledge and belief and that no material information has been withheld.
            <br><br>
            I am not aware of any matter which might cast doubt upon the worthiness of this individual to receive a Queen’s Award. I consent to all necessary enquiries being made by the Queen’s Awards Office in relation to this nomination. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any individual which might be granted a Queen’s Award to ensure the highest standards of propriety. I undertake to notify the Queen’s Awards Office of any changes to the information provided, including any changes to the nominee’s personal details.
          )
        end

        submit "Submit nomination" do
          notice %(
            <p>
              If you've answered all the questions you can now submit your nomination.
            </p>
            <p>
              You can still edit your submitted nomination at any time before 23:59 on the last working day of September.
            </p>
            <p>
              If you aren't ready to submit yet then you can save your nomination and come back later.
            </p>
          )
          style "large"
        end
      end
    end
  end
end
