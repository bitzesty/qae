class AwardYears::V2021::QaeForms
  class << self
    def trade_step6
      @trade_step6 ||= proc do
        header :head_of_bussines_header, "Head of your organisation" do
          ref "F 1"
        end

        text :head_of_bussines_title, "Title" do
          required
          classes "sub-question"
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
            I am happy to be contacted about Queen's Awards for Enterprise issues not related to my application (for example, acting as a case study, newsletters, other info).
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
              By submitting this entry for consideration for The Queen's Awards for Enterprise 2020, I certify that all the given particulars and those in any accompanying statements are correct to the best of my knowledge and belief and that no material information has been withheld. I undertake to notify The Queen's Awards Office of any changes to the information I have provided in this entry form.
            )
          end
        end

        confirm :shortlisted_case_confirmation_i_am_not_aware_of_any_matter, "" do
          ref "F 4.1"
          required
          show_ref_always true
          text %(
            I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a Queen's Award for Enterprise. I consent to all necessary enquiries being made by The Queen's Awards Office concerning this entry. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any business unit which might be granted a Queen's Award to ensure the highest standards of propriety.

            <p>
              <a href='#' class='js-form-expandable-content-link' data-ref='js-authorize-and-submit-step-view-gov-departments-and-agencies'>View Government Departments and Agencies we undertake due diligence checks with ></a>
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
            </p>
          )

          pdf_text %(
            I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a Queen's Award for Enterprise. I consent to all necessary enquiries being made by The Queen's Awards Office concerning this entry. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any business unit which might be granted a Queen's Award to ensure the highest standards of propriety.
          )
        end

        confirm :shortlisted_case_confirmation, "" do
          ref "F 4.2"
          required
          show_ref_always true
          text %(
            I agree that if the application is shortlisted, I will supply commercial figures verified by an independent accountant before the specified November deadline. I understand, that if verified figures are not provided by the specified deadline at shortlist stage, the entry will be rejected.
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
