class CaseSummaryPdfs::Pointer < ReportPdfFormAnswerPointerBase
  include CaseSummaryPdfs::General::DrawElements
  include CaseSummaryPdfs::General::DataPointer

  attr_reader :data

  def generate!
    #@data = form_answer. TODO
    main_header
    render_data!
  end
end
