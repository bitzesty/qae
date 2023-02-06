class AwardYears::V2024::QAEForms
  class << self
    def development_step6
      @development_step6 ||= proc do
        header :head_of_bussines_header, "Head of your organisation" do
          ref "F 1"
        end

        text :head_of_bussines_title, "Title" do
          required
          classes "sub-question"
          excluded_header_questions
          style "tiny"
        end

        head_of_business :head_of_business, "" do
          sub_fields([
            { first_name: "First name" },
            { last_name: "Last name" },
            { honours: "Personal Honours" }
          ])
        end

        text :head_job_title, "Job title/role in the organisation" do
          classes "sub-question"
          excluded_header_questions
          required
          form_hint %(
            For example, CEO, Managing Director, Founder
          )
        end

        text :head_email, "Email address" do
          classes "sub-question"
          excluded_header_questions
          style "large"
          required
          type "email"
        end

        confirm :confirmation_of_consent, "Confirmation of consent" do
          ref "F 2"
          required
          text "I confirm that I have the consent of the head of my organisation (as identified above) to submit this entry form."
        end

        confirm :agree_being_contacted_by_department_of_business, "" do
          sub_ref "F 3.1"
          show_ref_always true
          text %(
            I am happy to be contacted by the Department for Business, Energy and Industrial Strategy.
          )
        end

        confirm :due_diligence, "" do
          ref "F 4.1"
          required
          show_ref_always true
          text %(
            I understand and agree the outcome of the due diligence checks which The Queen's Awards for Enterprise Office undertakes with Government Departments and Agencies is final and cannot be overturned.
          )
        end

        confirm :shortlisted_case_confirmation, "" do
          ref "F 4.2"
          required
          show_ref_always true
          text %(
            I agree that if the application is shortlisted, if asked, I will supply actual commercial figures and the latest year's VAT returns by October/November.
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
