class Admin::ReportsController < Admin::BaseController
  def show
    respond_to do |format|
      format.html
      format.csv{ send_data resource.build }
    end
  end

  private

  def resource
    @report ||= Reports::AdminReport.new(params[:id])
  end
end
