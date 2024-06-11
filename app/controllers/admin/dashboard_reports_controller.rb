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
    render_or_download_report nil, permitted_kind_value, params[:format]
  end

  def international_trade
    render_or_download_report :trade, permitted_kind_value, params[:format]
  end

  def innovation
    render_or_download_report :innovation, permitted_kind_value, params[:format]
  end

  def social_mobility
    render_or_download_report :mobility, permitted_kind_value, params[:format]
  end

  def sustainable_development
    render_or_download_report :development, permitted_kind_value, params[:format]
  end

  def account_registrations
    authorize :dashboard, :reports?

    @report = Reports::Dashboard::UsersReport.new(kind: permitted_kind_value)

    respond_to do |format|
      format.csv do
        send_data @report.as_csv, filename: @report.csv_filename
      end

      format.html do
        render partial: "admin/dashboard/totals_#{permitted_kind_value}/users_table_body"
      end
    end
  end

  private

  def render_or_download_report award_type, kind, format
    authorize :dashboard, :reports?

    @report = Reports::Dashboard::ApplicationsReport.new(kind: kind, award_type: award_type)

    respond_to do |format|
      format.csv do
        send_data @report.as_csv, filename: @report.csv_filename
      end

      format.html do
        render partial: "admin/dashboard/totals_#{kind}/table_body"
      end
    end
  end

  def permitted_kind_value
    params[:kind] if params[:kind].presence.in?(%w[by_month by_week by_day])
  end
end
