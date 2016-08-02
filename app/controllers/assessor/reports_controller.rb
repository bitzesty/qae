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
    end
  end

  private

  def resource
    @report ||= Reports::AssessorReport.new(params[:id], @award_year, current_subject, params)
  end
end
