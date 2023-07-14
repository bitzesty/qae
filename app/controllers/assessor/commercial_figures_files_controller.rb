class Assessor::CommercialFiguresFilesController < Assessor::BaseController
  include AdminShortlistedDocsContext

  def relationship_name
    :commercial_figures_file
  end

  def resource_class
    CommercialFiguresFile
  end
end
