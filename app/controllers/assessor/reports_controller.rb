class Assessor::ReportsController < Assessor::BaseController
  def show
    authorize :report, :show?

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
