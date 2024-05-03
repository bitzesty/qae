class HardCopyPdfGenerators::Collection::CaseSummaryWorker < HardCopyPdfGenerators::BaseWorker
  def perform
    year = AwardYear.current

    return unless year.case_summary_generation_can_be_started?

    # Set status of generation process
    year.update_column(:case_summary_hard_copies_state, "started")

    # Schedule individual PDF generation worker per each FormAnswer entry
    AwardYear.current.hard_copy_case_summary_scope.find_each do |form_answer|
      HardCopyPdfGenerators::CaseSummaryWorker.perform_async(form_answer.id)
    end

    # Run check generation results scripe 6 hours later
    HardCopyPdfGenerators::StatusCheckers::CaseSummaryWorker.perform_at(6.hours.from_now)
  end
end
