class AwardYears::V2021::QaeForms
  class << self
    def development_step4
      @development_step4 ||= proc do
        upload :innovation_materials,
               "If there is additional material you feel would help us to assess your entry, then you can add up to 3 files or website addresses here." do
          ref "D 1"
          context %(
            <p>
              Please include any vital information in the form as we can't guarantee the additional material will be reviewed. It is also essential to reference these in your application to ensure the assessors are aware of them and can relate this information to the relevant questions.
            </p>
            <p>You can upload files in all common formats, as long as they're less than 5mb each.</p>
            <p>You may link to videos, websites or other media you feel relevant.</p>
            <p>We won't consider business plans, annual accounts or company policy documents. Additional materials should not be used as a substitute for completing sections of the form.</p>
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
      end
    end
  end
end
