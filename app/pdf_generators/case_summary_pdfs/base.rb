class CaseSummaryPdfs::Base < ReportPdfBase

  attr_reader :case_summaries

  def all_mode
    set_case_summaries

    if case_summaries.present?
      case_summaries.each_with_index do |feedback, index|
        start_new_page if index.to_i != 0
        render_item(feedback.form_answer)
      end
    else
      @missing_data_name = "case_summaries"
      render_not_found_block
    end
  end

  def set_case_summaries
    # TODO @case_summaries
  end

  def render_item(form_answer)
    CaseSummaryPdfs::Pointer.new(self, form_answer)
  end
end
