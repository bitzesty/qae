# -*- coding: utf-8 -*-
class QAE2014Forms
  class << self
    def promotion_step6
      @promotion_step6 ||= proc do
        header :user_info, "Your full name" do
          ref "F 1"
        end

        dropdown :title, "Title" do
          required
          option "prof", "Prof"
          option "dr", "Dr"
          option "mr", "Mr"
          option "mrs", "Mrs"
          option "miss", "Miss"
          option "other", "Other"
        end

        text :title_other, "Please specify" do
          classes "sub-question"
          conditional :title, "other"
        end

        text :first_name, "First name" do
          required
        end

        text :last_name, "Surname" do
          required
        end

        address :personal_address, "Personal address" do
          required
          ref "F 1.1"
        end

        text :phone, "Telephone number" do
          required
          style "small"
        end

        text :email, "Email address" do
          required
        end

        text :relationship_to_nominee, "Your relationship to the nominee" do
        end

        confirm :agree_being_contacted_about_issues_not_related_to_application, "" do
          ref "F 2"
          text "I am happy to be contacted about Queen's Award for Enterprise issues not related to my application (e.g. acting as a case study, newsletters, other info)."
        end

        confirm :agree_being_contacted_by_department_of_business, "" do
          ref "F 3"
          text "I am happy to be contacted by the Department of Business, Innovation and Skills."
        end

        options :agree_being_contacted_about_other_issues, "" do
          ref "F 4"
          context "We will notify you of the outcome of your nomination shortly before the public announcement of the winners. We may also want to contact you about other issues associated with The Queen’s Awards. Are you happy for us to do this?"
          yes_no
        end

        confirm :entry_confirmation, "Confirmation of entry" do
          ref "F 3"
          required
          text %(
            By ticking this box, I submit a nomination for consideration for the Queen’s Award for Enterprise Promotion 2015. I certify that all the particulars given, and those in any accompanying statements are correct to the best of my knowledge and belief and that no material information has been withheld.
            <br><br>
            I am not aware of any matter which might cast doubt upon the worthiness of this individual to receive a Queen’s Award. I consent to all necessary enquiries being made by the Queen’s Awards Office in relation to this nomination. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any individual which might be granted a Queen’s Award to ensure the highest standards of propriety. I undertake to notify the Queen’s Awards Office of any changes to the information provided, including any changes to the nominee’s personal details.*
                    )
        end

        submit "Submit application" do
          notice %(
            <p>If you have answered all the questions, you can submit your application now. You will be able to edit it any time before 23:59 on the last working day of September.</p>
            <p>
              If you are not ready to submit yet, you can save your application and come back later.
            </p>
                    )
          style "large"
        end
      end
    end
  end
end
