class Admin::ReportsController < Admin::BaseController
  expose(:pdf_data) do
    FeedbacksPdf.new("all")
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
                  filename: "application_feedbacks",
                  type: "application/pdf"
      end
    end
  end

  private

  def resource
    @report ||= Reports::AdminReport.new(params[:id])
  end
end
