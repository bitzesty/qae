class Admin::ReportsController < Admin::BaseController
  before_action :check_category, only: [:download_feedbacks_pdf]

  expose(:pdf_data) do
    FeedbackPdfs::Base.new("all", nil, {category: params[:category]})
  end

  def show
    authorize :report, :show?

    respond_to do |format|
      format.html
      format.csv { send_data resource.build }
    end
  end

  def download_feedbacks_pdf
    authorize :report, :show?

    respond_to do |format|
      format.pdf do
        send_data pdf_data.render,
                  filename: pdf_filename,
                  type: "application/pdf"
      end
    end
  end

  private

  def resource
    @report ||= Reports::AdminReport.new(params[:id])
  end

  def check_category
    unless FormAnswer::AWARD_TYPE_FULL_NAMES.keys.include?(params[:category])
      flash.alert = "Category should be in #{FormAnswer::AWARD_TYPE_FULL_NAMES.keys.join(', ')}"
      redirect_to admin_dashboard_index_path
      return
    end
  end

  def pdf_filename
    "#{FormAnswer::AWARD_TYPE_FULL_NAMES[params[:category]]}_award_feedbacks_#{pdf_timestamp}.pdf"
  end

  def pdf_timestamp
    Time.zone.now.strftime("%e_%b_%Y_at_%H:%M")
  end
end
