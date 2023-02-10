class AwardYears::V2024::QAEForms
  class << self
    def innovation_step6
      @innovation_step6 ||= proc do
        upload :innovation_materials, "If there is additional material you feel would help us to assess your entry, then you can add up to 3 files or website addresses here." do
          ref "E 1"
          context %(
            <p>
              Please include any vital information in the form as we can't guarantee the additional material will be reviewed. It is also essential to reference these in your application to ensure the assessors are aware of them and can relate this information to the relevant questions.
            </p>
            <p>
              We won't consider business plans, annual accounts or company policy documents. Additional materials should not be used as a substitute for completing sections of the form.
            </p>
            <p>
              You can upload files in most common formats, if they are less than 5 megabytes. You may link to videos, websites or other media you feel relevant.
            </p>
          )
          hint "What are the allowed file formats?", %(
            <p>
              You can upload any of the following file formats: chm, csv, diff, doc, docx, dot, dxf, eps, gif, gml, ics, jpg, kml, odp, ods, odt, pdf, png, ppt, pptx, ps, rdf, rtf, sch, txt, wsdl, xls, xlsm, xlsx, xlt, xml, xsd, xslt, zip.
            </p>
          )
          max_attachments 3
          links
          description
        end

        confirm :agree_being_contacted_about_issues_not_related_to_application, "Confirmation of contact." do
          ref "F 3"
          text %(
            I am happy to be contacted about Queen's Awards for Enterprise issues not related to my application (for example, acting as a case study, newsletters, other info).
          )
        end

        confirm :entry_confirmation, "Confirmation of entry." do
          ref "F 4"
          required
          text -> do
            %(
              By submitting this entry for consideration for The Queen's Awards for Enterprise #{AwardYear.current.year}, I certify that all the given particulars and those in any accompanying statements are correct to the best of my knowledge and belief and that no material information has been withheld. I undertake to notify The Queen's Awards Office of any changes to the information I have provided in this entry form.
            )
          end
        end

        confirm :shortlisted_case_confirmation, "" do
          ref "F 4.3"
          required
          show_ref_always true
          text %(
            I agree that if the application is shortlisted, I will supply commercial figures verified by an external accountant before the specified November deadline. I understand that if verified figures are not provided by the specified deadline at shortlist stage, the entry will be rejected.
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
