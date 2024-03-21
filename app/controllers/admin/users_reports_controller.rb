class Admin::UsersReportsController < Admin::BaseController
  def assessors_judges_admins_data
    authorize :reports, :show?

    @report = Reports::Admin::AssessorJudgeAdminDataReport.new()

    respond_to do |format|
      format.csv do
        send_data @report.as_csv, filename: @report.csv_filename
      end
    end
  end
end
