class CaseSummaryPdfs::Pointer < ReportPdfFormAnswerPointerBase
  include CaseSummaryPdfs::General::DrawElements
  include CaseSummaryPdfs::General::DataPointer

  attr_reader :data

  def generate!
    # fetch lead_case_summary or primary (if lead missing)
    @data = form_answer.lead_or_primary_assessor_assignments.first.document

    main_header
    render_data!
  end
end
