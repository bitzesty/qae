class AwardYears::V2024::QAEForms
  class << self
    def development_step5
      @development_step5 ||= proc do
        upload :innovation_materials, "Supplementary materials" do
          ref "E 1"
          context %(
            <p>If there is additional material you feel would help us to assess your entry, then you can add up to 3 files or website addresses here.</p>
            <h4 class="govuk-heading-s">What can and cannot be included:</h3>
            <ul>
              <li>You can include links to promotional videos, websites, other media, or documents you feel are relevant and help illustrate your application.</li>
              <li>We will not consider business plans, annual accounts or company policy documents.</li>
            </ul>
            <h4 class="govuk-heading-s">Please note:</h3>
            <ul>
              <li>For assessors to review the supporting material, you must reference them by their names in your answers. Please do so to ensure they are reviewed.</li>
              <li>Do not use the supporting material as a substitute for providing narrative answers to the questions.</li>
              <li>Assessors have limited time to evaluate your application, so any additional documents should be kept short and relevant.</li>
            </ul>
          )
          pdf_context %(
            <p>If there is additional material you feel would help us to assess your entry, then you can add up to 3 files or website addresses here.</p>
            <h4 class="govuk-heading-s">What can and cannot be included:</h3>
            <p>
              \u2022 You can include links to promotional videos, websites, other media, or documents you feel are relevant and help illustrate your application.
              \u2022 We will not consider business plans, annual accounts or company policy documents.
            </p>
            <h4 class="govuk-heading-s">Please note:</h3>
            <p>
              \u2022 For assessors to review the supporting material, you must reference them by their names in your answers. Please do so to ensure they are reviewed.
              \u2022 Do not use the supporting material as a substitute for providing narrative answers to the questions.
              \u2022 Assessors have limited time to evaluate your application, so any additional documents should be kept short and relevant.
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

        confirm :entry_confirmation, "Confirmation of entry" do
          ref "E 2"
          required
          text -> do
            %(
              By ticking this box, I submit an entry for consideration for The Queen's Awards for Enterprise #{AwardYear.current.year}. I certify that all the particulars given and those in any accompanying statements are correct to the best of my knowledge and belief and that no material information has been withheld. I undertake to notify The Queen's Awards Office of any changes to the information I have provided in this entry form.
              <br>
              <br>
              I am not aware of any matter which might cast doubt on the worthiness of my organisation to receive a Queen's Award for Enterprise. I consent to all necessary enquiries being made by The Queen's Awards Office concerning this entry. This includes enquiries made of Government Departments and Agencies in discharging its responsibilities to vet any business unit which might be granted a Queen's Award to ensure the highest standards of propriety.
            )
          end
        end
      end
    end
  end
end
