module CaseSummaryPdfs::General::DataPointer
  def case_summaries_table_headers
    # TODO
  end

  def case_summaries_entries
    # TODO
  end

  def render_data!
    table_items = case_summaries_entries
    render_headers(case_summaries_table_headers)
    render_table(table_items)
  end
end
