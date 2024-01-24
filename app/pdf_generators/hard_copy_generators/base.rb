class HardCopyGenerators::Base

  attr_reader :form_answer,
              :pdf,
              :tempfile_name,
              :timestamp,
              :tmpfile,
              :use_latest_version

  def initialize(form_answer, use_latest_version=false)
    @form_answer = form_answer
    @use_latest_version = use_latest_version
    @timestamp = Time.zone.now.strftime('%d_%b_%Y_%H_%M')

    set_pdf!
  end

  def run
    # Create a tempfile
    @tmpfile = Tempfile.new([tempfile_name, '.pdf'])
  
    begin
      # set to binary mode to avoid UTF-8 conversion errors
      tmpfile.binmode
  
      # Use render to write the file contents
      tmpfile.write pdf.render
  
      # Upload the tempfile with your Carrierwave uploader
      attach_generated_file!
    ensure
      # Close the tempfile and delete it
      tmpfile.close
      tmpfile.unlink if tmpfile
    end
  end

  private

  def tempfile_name
    "#{file_prefix}_#{form_answer.urn}_#{timestamp}_SEPARATOR".gsub("/", "_")
  end

  def original_filename
    "#{file_prefix}_#{form_answer.urn}.pdf"
  end
end
