class AwardYears::V2024::QAEForms
  class << self
    def mobility_step1
      @mobility_step1 ||= proc do
        header :consent_due_diligence_header, "" do
          section_info
          context %(
            <h3 class="govuk-heading-m">About section A</h3>
            <p class="govuk-body">This section is to confirm that you have the authorisation to apply, that your organisation is financially stable, worthy, and that you understand what will happen after you apply in terms of due diligence. We recommend you carefully answer section A questions before proceeding with the rest of the application.</p>
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

        header :head_of_bussines_header, "Details of the head of the organisation" do
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
            { honours: "Personal Honours (optional)" }
          ])
        end

        text :head_job_title, "Job title / role in the organisation" do
          classes "sub-question"
          excluded_header_questions
          required
        end

        text :head_email, "Email address" do
          classes "sub-question"
          excluded_header_questions
          style "large"
          required
          type "email"
        end

        header :due_diligence_header, "Organisation worthiness & due diligence checks" do
          ref "A 2"
          context %{
            <p class="govuk-body">Before you apply, please consider any issues that may prevent your application from receiving routine clearance as part of the due diligence process that we undertake with a number of Government Departments and Agencies. For example, this may be fines or penalties you have received or non-compliance with regulations.</p>
            <p class="govuk-body">Therefore please check with your accountant and legal representatives if there are any outstanding or recent issues, as The King's Awards for Enterprise Office starts the due diligence process immediately after the submission and is unable to repeat the due diligence process.</p>
            <p class="govuk-body">Some examples of issues that may prevent your organisation from receiving final clearance for The King's Awards for Enterprise Award:</p>
            <ul class="govuk-list govuk-list--bullet">
              <li>Fines or penalties;</li>
              <li>Non-compliance with regulations;</li>
              <li>Failure to pay staff the minimum wage;</li>
              <li>Accident within the workplace, which has resulted in harm being caused to the environment or employees;</li>
              <li>Failure to fully comply with administrative filing requirements as stipulated by any Government Department or Agency.</li>
            </ul>
            <details class='govuk-details govuk-!-margin-top-3 govuk-!-margin-bottom-0' data-module="govuk-details">
              <summary class="govuk-details__summary">
                <span class="govuk-details__summary-text">
                  View Government Departments and Agencies we undertake due diligence checks with
                </span>
              </summary>
              <div class="govuk-details__text">
                <ul>
                  <li>Biotechnology & Biological Sciences Research Council</li>
                  <li>Cabinet Office</li>
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
          }
          pdf_context_with_header_blocks [
            [:normal, %(
              Before you apply, please consider any issues that may prevent your application from receiving routine clearance as part of the due diligence process that we undertake with a number of Government Departments and Agencies. For example, this may be fines or penalties you have received or non-compliance with regulations.

              Therefore please check with your accountant and legal representatives if there are any outstanding or recent issues, as The King's Awards for Enterprise Office starts the due diligence process immediately after the submission and is unable to repeat the due diligence process.

              Some examples of issues that may prevent your organisation from receiving final clearance for The King's Awards for Enterprise Award:

              \u2022 Fines or penalties;
              \u2022 Non-compliance with regulations;
              \u2022 Failure to pay staff the minimum wage;
              \u2022 Accident within the workplace, which has resulted in harm being caused to the environment or employees;
              \u2022 Failure to fully comply with administrative filing requirements as stipulated by any Government Department or Agency.

              Government Departments and Agencies we undertake due diligence checks with:

              \u2022 Biotechnology & Biological Sciences Research Council
              \u2022 Cabinet Office
              \u2022 Charity Commission
              \u2022 Companies House
              \u2022 Competition and Markets Authority
              \u2022 Crown Commercial Service
              \u2022 Department for Business, Energy and Industrial Strategy
              \u2022 Department for Communities and Local Government
              \u2022 Department for Culture Media & Sport
              \u2022 Department for Education
              \u2022 Department for Environment, Food & Rural Affairs
              \u2022 Department for International Trade
              \u2022 Department for Transport
              \u2022 Department of Economic Development, Isle of Man
              \u2022 Department for the Economy NI
              \u2022 Department of Health
              \u2022 Environment Agency
              \u2022 Financial Conduct Authority
              \u2022 Food Standards Agency
              \u2022 Forestry Commission
              \u2022 Guernsey Government
              \u2022 Health and Safety Executive
              \u2022 HM Courts & Tribunals Service
              \u2022 HM Revenue & Customs
              \u2022 Home Office
              \u2022 Insolvency Service
              \u2022 Intellectual Property Office
              \u2022 Invest NI
              \u2022 Jersey Government
              \u2022 Ministry of Defence
              \u2022 Ministry of Justice
              \u2022 Medical Research Council Technology
              \u2022 National Measurement Office
              \u2022 Natural England
              \u2022 Natural Environment Research Council
              \u2022 Office of the Scottish Charity Regulator
              \u2022 Scottish Government
              \u2022 Scottish Environment Protection Agency
              \u2022 Scottish Funding Council
              \u2022 Serious Fraud Office
              \u2022 UK Export Finance
              \u2022 Wales Government
            )]
          ]
        end

        confirm :shortlisted_case_confirmation_i_am_not_aware_of_any_matter, "" do
          ref "A 2.1"
          required
          show_ref_always true
          text %(
            I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a King's Award for Enterprise.
          )
        end

        confirm :agree_being_contacted_by_kao, "Consent to enquiries by The King's Awards Office" do
          ref "A 2.2"
          required
          show_ref_always true
          text %(
            I consent to all necessary enquiries being made by The King's Awards Office concerning this entry. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any business unit which might be granted a King's Award to ensure the highest standards of propriety.
          )
        end

        confirm :due_diligence, "Agree to the outcome of the due diligence checks" do
          ref "A 2.3"
          required
          show_ref_always true
          text %(
            I understand and agree that the outcome of the due diligence checks which The King's Awards for Enterprise Office undertakes with Government Departments and Agencies is final and cannot be overturned.
          )
        end

        confirm :shortlisted_case_confirmation, "Commercial performance" do
          ref "A 3"
          required
          show_ref_always true
          text %(
            I understand that I have to provide financial information and related financial statements for the last three years to demonstrate that the organisation is financially viable.
          )
        end
      end
    end
  end
end
