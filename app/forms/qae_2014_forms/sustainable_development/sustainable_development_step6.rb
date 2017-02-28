class QAE2014Forms
  class << self
    def development_step6
      @development_step6 ||= proc do
        header :head_of_bussines_header, "Head of your organisation" do
          ref "F 1"
        end

        text :head_of_bussines_title, "Title" do
          required
          classes "regular-question"
          style "tiny"
        end

        head_of_business :head_of_business, "" do
          sub_fields([
            { first_name: "First name" },
            { last_name: "Last name" },
            { honours: "Personal Honours" }
          ])
        end

        text :head_job_title, "Job title / role in the organisation" do
          classes "sub-question"
          required
          form_hint %(
            e.g. CEO, Managing Director, Founder
          )
        end

        text :head_email, "Email address" do
          classes "sub-question"
          style "large"
          required
        end

        confirm :confirmation_of_consent, "Confirmation of consent" do
          ref "F 2"
          required
          text "I confirm that I have the consent of the head of my organisation (as identified above) to submit this entry form."
        end

        confirm :agree_being_contacted_about_issues_not_related_to_application, "Confirmation of contact" do
          ref "F 3"
          text %(
            I am happy to be contacted about Queen's Awards for Enterprise issues not related to my application (e.g. acting as a case study, newsletters, other info).
          )
        end

        confirm :agree_being_contacted_by_department_of_business, "" do
          sub_ref "F 3.1"
          show_ref_always true
          text %(
            I am happy to be contacted by the Department for Business, Energy and Industrial Strategy.
          )
        end

        confirm :entry_confirmation, "Confirmation of entry" do
          ref "F 4"
          required
          text %(
            By ticking this box, I submit an entry for consideration for The Queen's Awards for Enterprise #{AwardYear.current.year}. I certify that all the particulars given and those in any accompanying statements are correct to the best of my knowledge and belief and that no material information has been withheld. I undertake to notify The Queen's Awards Office of any changes to the information I have provided in this entry form.
            <br>
            <br>
            I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a Queen's Award for Enterprise. I consent to all necessary enquiries being made by The Queen's Awards Office in relation to this entry. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any business unit which might be granted a Queen's Award to ensure the highest standards of propriety.
          )
        end

        confirm :shortlisted_case_confirmation, "" do
          ref "F 4.1"
          required
          show_ref_always true
          text %(
            By ticking this box, you agree that if your application is shortlisted you will supply
            verified commercial figures before the specified deadline.
            <br>
            <br>
            If verified figures are not provided by [AUDIT_CERTIFICATES_DEADLINE], your entry will be rejected.
          )
        end

        submit "Submit application" do
          notice %(
            <p>
              If you have answered all the questions, you can submit your application now. You will be able to edit it any time before [SUBMISSION_ENDS_TIME].
            </p>
            <p>
              If you are not ready to submit yet, you can save your application and come back later.
            </p>
          )
        end
      end
    end
  end
end
