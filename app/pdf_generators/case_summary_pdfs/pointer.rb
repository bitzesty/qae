class CaseSummaryPdfs::Pointer < ReportPdfFormAnswerPointerBase
  include CaseSummaryPdfs::General::DrawElements
  include CaseSummaryPdfs::General::DataPointer

  attr_reader :data, :financial_pointer

  def generate!
    # fetch lead_case_summary or primary (if lead missing)
    @data = form_answer.lead_or_primary_assessor_assignments.first.document

    if !form_answer.promotion? && form_answer.submitted?
      @financial_pointer = FormFinancialPointer.new(form_answer, {exclude_ignored_questions: true})
    end

    main_header
    render_data!
  end
end
