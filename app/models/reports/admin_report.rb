class Reports::AdminReport
  attr_reader :id, :year, :params

  VALID_REPORT_IDENTIFIERS = [
    "registered-users",
    "compiled-press-book",
    "press-book-list",
    "cases-status",
    "case-index",
    "feedbacks",
    "case_summaries",
    "entries-report",
    "discrepancies_between_primary_and_secondary_appraisals",
    "reception-buckingham-palace",
    /assessors-progress/,
  ]

  def initialize(id, year, params = {})
    @id = valid_identifier(id)
    @year = year
    @params = params
  end

  def as_csv
    case id
    when "registered-users"
      Reports::RegisteredUsers.new(year).stream
    when "press-book-list"
      Reports::PressBookList.new(year).stream
    when "cases-status"
      Reports::CasesStatusReport.new(year).stream
    when "case-index"
      Reports::CaseIndexReport.new(year, category: category, years_mode: years_mode).stream
    when "entries-report"
      Reports::AllEntries.new(year).stream
    when "discrepancies_between_primary_and_secondary_appraisals"
      Reports::DiscrepanciesBetweenPrimaryAndSecondaryAppraisals.new(year, params[:category]).stream
    when "reception-buckingham-palace"
      Reports::ReceptionBuckinghamPalaceReport.new(year).stream
    when /assessors-progress/
      if category.present?
        Reports::AssessorsProgressReport.new(year, category).build
      else
        raise ArgumentError, "Invalid category"
      end
    end
  end

  def csv_filename
    sub_type = ""
    if category == "trade" &&
        id == "case-index" &&
        year.year != 2016
      # For 2016 we use one report for both trade years modes ('3 to 5' and '6 plus')
      sub_type = "_#{years_mode}"
    end

    case id
    when "case-index"
      time = Time.zone.now.strftime("%e_%b_%Y_at_%-l:%M%P")
      "#{category}_award#{sub_type}_#{id}_#{time}.csv"
    when "reception-buckingham-palace"
      "royal-reception-guest-list.csv"
    when "registered-users"
      "users-of-started-applications.csv"
    end
  end

  def as_xlsx
    case id
    when "compiled-press-book"
      Reports::CompiledPressBook.new(year).build
    end
  end

  def as_pdf
    pdf_klass = case id
    when "feedbacks"
      FeedbackPdfs::Base
    when "case_summaries"
      CaseSummaryPdfs::Base
    end

    sub_type = ""
    if category == "trade" &&
        id == "case_summaries" &&
        year.year != 2016
      # For 2016 we use one report for both trade years modes ('3 to 5' and '6 plus')
      sub_type = "_#{years_mode}"
    end

    attachment = year.send(:"#{id.singularize}_#{category}#{sub_type}_hard_copy_pdf")

    if year.send(:"aggregated_#{id.singularize}_hard_copy_state").to_s == "completed" &&
        attachment.present? &&
        attachment.file.present?
      # Render Hard Copy if it's generated for this year

      OpenStruct.new(
        hard_copy: true,
        data: (Rails.env.development? ? attachment.file.read : attachment.file.url),
        filename: attachment.original_filename,
      )
    else
      # Render dynamically
      ops = { category: category, award_year: year }
      ops[:years_mode] = years_mode if category == "trade"

      data = pdf_klass.new("all", nil, ops)

      OpenStruct.new(
        data: data.render,
        filename: pdf_filename(sub_type),
      )
    end
  end

  private

  def valid_identifier(identifier)
    case identifier
    when *VALID_REPORT_IDENTIFIERS
      identifier
    else
      raise ArgumentError, "Invalid category"
    end
  end

  def category
    params[:category] if ::FormAnswer::AWARD_TYPE_FULL_NAMES.key?(params[:category])
  end

  def years_mode
    params[:years_mode] if ::AwardYear::CASE_SUMMARY_YEAR_MODES.include?(params[:years_mode])
  end

  def pdf_filename(sub_type)
    sub_type = "#{sub_type}_years" if sub_type.present?

    pdf_timestamp = Time.zone.now.strftime("%e_%b_%Y_at_%-l:%M%P")
    "#{category}_award#{sub_type}_#{id}_#{pdf_timestamp}.pdf"
  end
end
