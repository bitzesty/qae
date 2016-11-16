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
    when /assessors-progress/
      if FormAnswer::AWARD_TYPE_FULL_NAMES.keys.include?(params[:category])
        Reports::AssessorsProgressReport.new(year, params[:category]).build
      else
        raise ArgumentError, "Invalid category"
      end
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
    sub_type = "_#{params[:years_mode]}" if category == "trade" && id == "case_summaries"

    attachment = year.send("#{id.singularize}_#{category}#{sub_type}_hard_copy_pdf")

    if year.send("aggregated_#{id.singularize}_hard_copy_state").to_s == "completed" &&
       attachment.present? &&
       attachment.file.present?
      # Render Hard Copy if it's generated for this year

      OpenStruct.new(
        hard_copy: true,
        data: (Rails.env.development? ? attachment.file.read : attachment.file.url),
        filename: attachment.original_filename
      )
    else
      # Render dynamically
      ops = {category: category, award_year: year}
      ops[:years_mode] = params[:years_mode] if category == "trade"

      data = pdf_klass.new("all", nil, ops)

      OpenStruct.new(
        data: data.render,
        filename: pdf_filename
      )
    end
  end

  private

  def category
    params[:category] if ::FormAnswer::AWARD_TYPE_FULL_NAMES.keys.include?(params[:category])
  end

  def pdf_filename
    pdf_timestamp = Time.zone.now.strftime("%e_%b_%Y_at_%-l:%M%P")
    "#{::FormAnswer::AWARD_TYPE_FULL_NAMES[params[:category]]}_award_#{id}_#{pdf_timestamp}.pdf"
  end
end
