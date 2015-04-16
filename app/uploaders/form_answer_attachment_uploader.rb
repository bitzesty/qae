class FormAnswerAttachmentUploader < FileUploader
  POSSIBLE_IMG_EXTENSIONS = %w(jpg jpeg gif png)

  def extension_white_list
    POSSIBLE_IMG_EXTENSIONS + %w(chm csv diff doc docx dot dxf eps gml ics kml odp ods odt pdf ppt pptx ps rdf rtf sch txt wsdl xls xlsm xlsx xlt xml xsd xslt zip)
  end
end
