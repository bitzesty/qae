# On the day of the application submission deadline,
# generates a hard copy of the pdf and saves it

# Use:
# ApplicationHardCopyPdfGenerator.new(form_answer).run
#

class ApplicationHardCopyPdfGenerator

  attr_reader :form_answer,
              :pdf,
              :tempfile_name

  def initialize(form_answer)
    @form_answer = form_answer
    @pdf = form_answer.original_form_answer
                      .decorate
                      .pdf_generator

    timestamp = form_answer.submission_end_date.strftime('%d_%b_%Y_%H_%M')
    @tempfile_name = "application_#{form_answer.urn}_#{timestamp}_SEPARATOR".gsub("/", "_")
  end

  def run
    # Create a tempfile
    tmpfile = Tempfile.new([tempfile_name, '.pdf'])

    # set to binary mode to avoid UTF-8 conversion errors
    tmpfile.binmode

    # Use render to write the file contents
    tmpfile.write pdf.render

    # Upload the tempfile with your Carrierwave uploader
    form_answer.pdf_version = tmpfile
    form_answer.save!

    # Close the tempfile and delete it
    tmpfile.close
    tmpfile.unlink
  end
end
