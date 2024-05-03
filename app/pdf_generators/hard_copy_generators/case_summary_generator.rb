# On the day then Final Stage - Winners notifications are sent,
# generates a hard copy of the Case Summary PDF for each FormAnswer
# which have it

# Use:
# HardCopyGenerators::CaseSummaryGenerator.new(form_answer).run
#

class HardCopyGenerators::CaseSummaryGenerator < HardCopyGenerators::Base
  def set_pdf!
    @pdf = form_answer.decorate.case_summaries_pdf_generator
  end

  def file_prefix
    "case_summary"
  end

  def attach_generated_file!
    pdf_record = form_answer.build_case_summary_hard_copy_pdf(
      file: tmpfile,
      original_filename:,
    )

    return unless pdf_record.save!

    form_answer.update_column(:case_summary_hard_copy_generated, true)
  end
end
