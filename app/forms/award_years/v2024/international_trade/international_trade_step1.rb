class AwardYears::V2024::QAEForms
  class << self
    def trade_step1
      @trade_step1 ||= proc do
        header :consent_due_diligence_header, "" do
          section_info
          context %(
            <p class='govuk-body'>This section is to confirm that you have the authorisation to apply, that your organisation is worthy and that you understand what will happen after you apply in terms of due diligence and verification of commercial figures. We recommend you carefully answer section A questions before proceeding with the rest of the application.</p>
          )
        end

        confirm :confirmation_of_consent, "Consent to apply by the head of organisation" do
          ref "A 1.1"
          required
          text %(
            I confirm that I have the consent of the head of my organisation to fill in and submit this entry form.
          )
        end

        header :head_of_bussines_header, "Details of the head of  your organisation" do
          ref "A 1.2"
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

        text :head_job_title, "Job title or role in the organisation" do
          classes "sub-question"
          excluded_header_questions
          required
          form_hint %(
            For exmaple CEO, Managing Director, Founder
          )
        end

        text :head_email, "Email address" do
          classes "sub-question"
          excluded_header_questions
          style "large"
          required
          type "email"
        end

        header :due_diligence_header, "" do
          ref "A 2"
          context %{
            <p>Please be aware that due diligence checks inform the decision to grant an award.</p>
          }
        end

        confirm :agree_being_contacted_about_issues_not_related_to_application, "Confirmation of contact" do
          ref "F 3"
          text %(
            I am happy to be contacted about King's Awards for Enterprise issues not related to my application (for example, acting as a case study, newsletters, other info).
          )
        end

        confirm :agree_being_contacted_by_department_of_business, "" do
          sub_ref "F 3.1"
          text %(
            I am happy to be contacted by the Department for Business, Energy & Industrial Strategy.
          )
          show_ref_always true
        end

        confirm :entry_confirmation, "Confirmation of entry" do
          ref "F 4"
          required
          text -> do
            %(
              By submitting this entry for consideration for The King's Awards for Enterprise #{AwardYear.current.year}, I certify that all the given particulars and those in any accompanying statements are correct to the best of my knowledge and belief and that no material information has been withheld. I undertake to notify The King's Awards Office of any changes to the information I have provided in this entry form.
            )
          end
        end

        confirm :shortlisted_case_confirmation_i_am_not_aware_of_any_matter, "" do
          ref "F 4.1"
          required
          show_ref_always true
          text %(
            I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a King's Award for Enterprise. I consent to all necessary enquiries being made by The King's Awards Office concerning this entry. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any business unit which might be granted a King's Award to ensure the highest standards of propriety.

            <details class="govuk-details" data-module="govuk-details">
              <summary class="govuk-details__summary">
                <span class="govuk-details__summary-text">
                  View Government Departments and Agencies we undertake due diligence checks with
                </span>
              </summary>
              <div class="govuk-details__text">
                <ul class='js-authorize-and-submit-step-view-gov-departments-and-agencies hidden'>
                  <li>Biotechnology & Biological Sciences Research Council</li>
                  <li>Charity Commission</li>
                  <li>Companies House</li>
                  <li>Competition and Markets Authority</li>
                  <li>Crown Commercial Service</li>
                  <li>Department for Business, Energy and Industrial Strategy</li>
                  <li>Department for Communities and Local Government</li>
                  <li>Department for Culture Media & Sport</li>
                  <li>Department for Education</li>
                  <li>Department for Environment, Food & Rural Affairs</li>
                  <li>Department for International Trade</li>
                  <li>Department for Transport</li>
                  <li>Department of Economic Development, Isle of Man</li>
                  <li>Department for the Economy NI</li>
                  <li>Department of Health</li>
                  <li>Environment Agency</li>
                  <li>Financial Conduct Authority</li>
                  <li>Food Standards Agency</li>
                  <li>Forestry Commission</li>
                  <li>Guernsey Government</li>
                  <li>Health and Safety Executive</li>
                  <li>HM Courts & Tribunals Service</li>
                  <li>HM Revenue & Customs</li>
                  <li>Home Office</li>
                  <li>Insolvency Service</li>
                  <li>Intellectual Property Office</li>
                  <li>Invest NI</li>
                  <li>Jersey Government</li>
                  <li>Ministry of Defence</li>
                  <li>Ministry of Justice</li>
                  <li>Medical Research Council Technology</li>
                  <li>National Measurement Office</li>
                  <li>Natural England</li>
                  <li>Natural Environment Research Council</li>
                  <li>Office of the Scottish Charity Regulator</li>
                  <li>Scottish Government</li>
                  <li>Scottish Environment Protection Agency</li>
                  <li>Scottish Funding Council</li>
                  <li>Serious Fraud Office</li>
                  <li>UK Export Finance</li>
                  <li>Wales Government</li>
                </ul>
              </div>
            </details>
          )

          pdf_text %(
            I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a King's Award for Enterprise. I consent to all necessary enquiries being made by The King's Awards Office concerning this entry. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any business unit which might be granted a King's Award to ensure the highest standards of propriety.
          )
        end

        confirm :due_diligence, "" do
          ref "F 4.2"
          required
          show_ref_always true
          text %(
            I understand and agree the outcome of the due diligence checks which The King's Awards for Enterprise Office undertakes with Government Departments and Agencies is final and cannot be overturned.
          )
        end

        confirm :shortlisted_case_confirmation, "" do
          ref "F 4.3"
          required
          show_ref_always true
          text %(
            I agree that if the application is shortlisted, I will supply commercial figures verified by an external accountant before the specified November deadline. I understand, that if verified figures are not provided by the specified deadline at shortlist stage, the entry will be rejected.
          )
        end

        submit "Submit application" do
          notice %(
            <p>
              If you've answered all the questions, you can submit your application now. You will be able to edit it any time before [SUBMISSION_ENDS_TIME].
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
