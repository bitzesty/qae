# -*- coding: utf-8 -*-
class AwardYears::V2018::QaeForms
  class << self
    def promotion_step6
      @promotion_step6 ||= proc do
        header :user_info_header, "Your full name" do
          ref "F 1"
        end

        text :user_info_title, "Title" do
          required
          classes "sub-question"
          style "tiny"
        end

        user_info :user_info, "" do
          required
          sub_fields([
            { first_name: "First name" },
            { last_name: "Surname" },
          ])
        end

        address :personal_address, "Your personal address" do
          required
          sub_fields([
            { building: "Building" },
            { street: "Street" },
            { city: "Town or city" },
            { county: "County" },
            { postcode: "Postcode" },
          ])
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

        confirm :agree_being_contacted_about_issues_not_related_to_application, "Confirmation of contact" do
          ref "F 2"
          text "I am happy to be contacted about Queen's Awards for Enterprise issues not related to my application (e.g. acting as a case study, newsletters, other info)."
        end

        confirm :agree_being_contacted_by_department_of_business, "" do
          sub_ref "F 2.1"
          text "I am happy to be contacted by the Department for Business, Energy and Industrial Strategy."
        end

        confirm :entry_confirmation, "Confirmation of entry" do
          ref "F 3"
          required
          text %(
            By ticking this box, I submit a nomination for consideration for The Queen's Award for Enterprise Promotion 2016. I certify that all the particulars given, and those in any accompanying statements are correct to the best of my knowledge and belief and that no material information has been withheld.
            <br><br>
            I am not aware of any matter which might cast doubt upon the worthiness of this individual to receive a Queen's Award. I consent to all necessary enquiries being made by The Queen's Awards Office in relation to this nomination. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any individual which might be granted a Queen's Award to ensure the highest standards of propriety. I undertake to notify The Queen's Awards Office of any changes to the information provided, including any changes to the nominee's personal details.
          )
        end

        submit "Submit nomination" do
          notice %(
            <p>
              If you've answered all the questions you can now submit your nomination.
            </p>
            <p>
              You can still edit your submitted nomination at any time before #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_time}.
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
