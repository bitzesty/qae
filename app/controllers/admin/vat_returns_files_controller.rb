class Admin::VatReturnsFilesController < Admin::BaseController
  include AdminShortlistedDocsContext

  def file_model_name
    "vat_returns_files"
  end
end
