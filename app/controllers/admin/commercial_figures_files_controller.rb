class Admin::CommercialFiguresFilesController < Admin::BaseController
  include AdminShortlistedDocsContext

  def file_model_name
    "commercial_figures_files"
  end
end
