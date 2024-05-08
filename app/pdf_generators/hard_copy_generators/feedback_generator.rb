# On the day then Final Stage - Unsuccessful notifications are sent,
# generates a hard copy of the Feedback PDF for each FormAnswer
# which have it

# Use:
# HardCopyGenerators::FeedbackGenerator.new(form_answer).run
#

class HardCopyGenerators::FeedbackGenerator < HardCopyGenerators::Base
  def set_pdf!
    @pdf = form_answer.decorate.feedbacks_pdf_generator
  end

  def file_prefix
    "feedback"
  end

  def attach_generated_file!
    pdf_record = form_answer.build_feedback_hard_copy_pdf(
      file: tmpfile,
      original_filename: original_filename,
    )

    if pdf_record.save!
      form_answer.update_column(:feedback_hard_copy_generated, true)
    end
  end
end
