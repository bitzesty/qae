class Reports::AdminReport
  attr_reader :id, :year, :params

  def initialize(id, year, params = {})
    @id = id
    @year = year
    @params = params
  end

  def as_csv
    case id
    when "registered-users"
      Reports::RegisteredUsers.new(year).build
    when "press-book-list"
      Reports::PressBookList.new(year).build
    when "cases-status"
      Reports::CasesStatusReport.new(year).build
    when "entries-report"
      Reports::AllEntries.new(year).build
    when "reception-buckingham-palace"
      Reports::ReceptionBuckinghamPalaceReport.new(year).build
    end
  end

  def as_pdf
    pdf_klass = case id
    when "feedbacks"
      FeedbackPdfs::Base
    when "case_summaries"
      CaseSummaryPdfs::Base
    end

    data = pdf_klass.new("all", nil, category: category, award_year: year)

    OpenStruct.new(
      data: data.render,
      filename: pdf_filename
    )
  end

  private

  def category
    params[:category] if ::FormAnswer::AWARD_TYPE_FULL_NAMES.keys.include?(params[:category])
  end

  def pdf_filename
    pdf_timestamp = Time.zone.now.strftime("%e_%b_%Y_at_%H:%M")
    "#{::FormAnswer::AWARD_TYPE_FULL_NAMES[params[:category]]}_award_#{id}_#{pdf_timestamp}.pdf"
  end
end
