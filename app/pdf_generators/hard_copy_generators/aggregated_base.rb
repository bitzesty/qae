class HardCopyGenerators::AggregatedBase < HardCopyGenerators::Base
  attr_accessor :award_category,
    :award_year,
    :type_of_report

  def initialize(award_category, award_year, type_of_report)
    @timestamp = Time.zone.now.strftime("%d_%b_%Y_%H_%M")
    @award_category = award_category
    @award_year = award_year
    @type_of_report = type_of_report

    set_pdf!
  end

  private

  def attach_generated_file!
    pdf_record = award_year.send(:"aggregated_#{type_of_report}_hard_copies").new(
      file: tmpfile,
      type_of_report: type_of_report,
      award_category: award_category,
      original_filename: "#{file_prefix}.pdf",
    )

    pdf_record.save!
  end

  def file_prefix
    subtype_line = ""

    if award_category == "trade" && type_of_report == "case_summary"
      subtype_line = "_#{sub_type}_years"
    end

    "aggregated_hard_copy_#{award_category}_#{type_of_report}#{subtype_line}_#{award_year.year}"
  end

  def tempfile_name
    "#{file_prefix}_#{timestamp}_SEPARATOR".gsub("/", "_")
  end
end
