class AwardYears::V2022::QaeForms
  class << self
    def mobility_step5
      @mobility_step5 ||= proc do
        upload :innovation_materials,
               "If there is additional material you feel would help us to assess your entry then you can add up to 5 files or website addresses here" do
          ref "E 1"
          context %(
            <p>
              Please include any vital information in the form as we can't guarantee the additional material will be reviewed. It is also essential to reference these in your application to ensure the assessors are aware of them and can relate this information to the relevant questions.
            </p>
            <p>You can upload files in all common formats, as long as they're less than 5mb each. You may link to videos, websites or other media you feel relevant.</p>
            <p>We won't consider business plans, annual accounts or company policy documents. Additional materials should not be used as a substitute for completing sections of the form.</p>
          )
          hint "What are the allowed file formats?", %(
            <p>
              You can upload any of the following file formats: chm, csv, diff, doc, docx, dot, dxf, eps, gif, gml, ics, jpg, kml, odp, ods, odt, pdf, png, ppt, pptx, ps, rdf, rtf, sch, txt, wsdl, xls, xlsm, xlsx, xlt, xml, xsd, xslt, zip.
            </p>
          )
          max_attachments 5
          links
          description
        end
      end
    end
  end
end
