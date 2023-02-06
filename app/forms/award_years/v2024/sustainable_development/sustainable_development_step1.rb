# -*- coding: utf-8 -*-
class AwardYears::V2024::QAEForms
  class << self
    def development_step1
      @development_step1 ||= proc do
        header :consent_and_due_diligence_header, "Consent & Due Diligence" do
          section_info
          context %(
            <h3 class='govuk-heading-m'>About section A</h3>
            <p class='govuk-body'>
              This section is to confirm that you have the authorisation to apply, that your organisation is financially stable, worthy, and that you understand what will happen after you apply in terms of due diligence. We recommend you carefully answer section A questions before proceeding with the rest of the application.
            </p>
          )
          pdf_context_with_header_blocks [
            [:bold, "About section A"],
            [:normal, %(
              This section is to confirm that you have the authorisation to apply, that your organisation is financially stable, worthy, and that you understand what will happen after you apply in terms of due diligence. We recommend you carefully answer section A questions before proceeding with the rest of the application.
            )]
          ]
        end

        confirm :confirmation_of_consent, "Consent to apply by head of organisation" do
          ref "A 1.1"
          required
          text "I confirm that I have the consent of the head of my organisation to fill in and submit this entry form."
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
      end
    end
  end
end
