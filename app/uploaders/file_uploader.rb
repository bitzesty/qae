class FileUploader < CarrierWave::Uploader::Base
  def extension_white_list
    %w(jpg jpeg gif png chm csv diff doc docx dot dxf eps gml ics kml odp ods odt pdf ppt pptx ps rdf rtf sch txt wsdl xls xlsm xlsx xlt xml xsd xslt zip)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
