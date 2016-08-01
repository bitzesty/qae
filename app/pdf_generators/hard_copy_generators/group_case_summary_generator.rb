# On the day then Final Stage - Winners notifications are sent,
# generates a hard copy of the Group Case Summary PDF for all FormAnswers together
# which have it

# Use:
# HardCopyGenerators::GroupCaseSummaryGenerator.new(form_answer).run
#

class HardCopyGenerators::GroupCaseSummaryGenerator < HardCopyGenerators::Base
  def set_pdf!
    # @pdf = form_answer.original_form_answer
    #                   .decorate
    #                   .pdf_generator
  end

  def file_prefix
    "application"
  end

  def attach_generated_file!
    form_answer.pdf_version = tmpfile
    form_answer.save!
  end
end
