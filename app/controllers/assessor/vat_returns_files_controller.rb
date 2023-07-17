class Assessor::VatReturnsFilesController < Assessor::BaseController
  include AdminShortlistedDocsContext

  def relationship_name
    :vat_returns_files
  end

  def resource_class
    VatReturnsFile
  end
end
