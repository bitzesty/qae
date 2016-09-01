class Assessor::ReportsController < Assessor::BaseController

  def index
    authorize :report, :show?
  end

  def show
    authorize :report, :show?
    log_action params[:id]

    respond_to do |format|
      format.html

      format.csv do
        send_data resource.as_csv, type: "text/csv"
      end

      format.pdf do
        pdf = Reports::AdminReport.new(params[:id], @award_year, params).as_pdf

        if pdf[:hard_copy].blank? || Rails.env.development?
          send_data pdf.data,
                    filename: pdf.filename,
                    type: "application/pdf"
        else
          redirect_to pdf.data
        end
      end
    end
  end

  private

  def resource
    @report ||= Reports::AssessorReport.new(params[:id], @award_year, current_subject, params)
  end
end
