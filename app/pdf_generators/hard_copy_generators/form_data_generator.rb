# On the day of the application submission deadline,
# generates a hard copy of the pdf and saves it

# Use:
# HardCopyGenerators::FormDataGenerator.new(form_answer).run
#

class HardCopyGenerators::FormDataGenerator < HardCopyGenerators::Base
  def set_pdf!
    form_record = if use_latest_version
                    form_answer
                  else
                    form_answer.original_form_answer
                  end

    @pdf = form_record.decorate
                      .pdf_generator
  end

  def file_prefix
    "application"
  end

  def attach_generated_file!
    form_answer.pdf_version = tmpfile
    form_answer.form_data_hard_copy_generated = true

    form_answer.save!
  end
end
