class HardCopyPdfGenerators::Collection::FormDataWorker < HardCopyPdfGenerators::BaseWorker

  def perform
    year = AwardYear.current

    if year.form_data_generation_can_be_started?
      # Set status of generation process
      year.update_column(:form_data_hard_copies_state, "started")

      # Schedule individual PDF generation worker per each FormAnswer entry
      AwardYear.current.form_answers.submitted.find_each do |form_answer|
        HardCopyPdfGenerators::FormDataWorker.perform_async(form_answer.id)
      end

      # Run check generation results scripe 6 hours later
      HardCopyPdfGenerators::StatusCheckers::FormDataWorker.perform_at(6.hours.from_now)
    end
  end
end
