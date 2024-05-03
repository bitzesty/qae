class Admin::DashboardReportsController < Admin::BaseController
  # all methods accept the following params:
  # params[:kind]
  # - by_month
  # - by_week
  # - by_day
  # Methods for specific application kinds also accept
  # params[:award_type]
  # that represents the type of the application

  def all_applications
    render_or_download_report nil, params[:kind], params[:format]
  end

  def international_trade
    render_or_download_report :trade, params[:kind], params[:format]
  end

  def innovation
    render_or_download_report :innovation, params[:kind], params[:format]
  end

  def social_mobility
    render_or_download_report :mobility, params[:kind], params[:format]
  end

  def sustainable_development
    render_or_download_report :development, params[:kind], params[:format]
  end

  def account_registrations
    authorize :dashboard, :reports?

    @report = Reports::Dashboard::UsersReport.new(kind: params[:kind])

    respond_to do |format|
      format.csv do
        send_data @report.as_csv, filename: @report.csv_filename
      end

      format.html do
        render partial: "admin/dashboard/totals_#{params[:kind]}/users_table_body"
      end
    end
  end

  private

  def render_or_download_report(award_type, kind, _format)
    authorize :dashboard, :reports?

    @report = Reports::Dashboard::ApplicationsReport.new(kind:, award_type:)

    respond_to do |format|
      format.csv do
        send_data @report.as_csv, filename: @report.csv_filename
      end

      format.html do
        render partial: "admin/dashboard/totals_#{kind}/table_body"
      end
    end
  end
end
