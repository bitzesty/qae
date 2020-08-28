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
    authorize :dashboard, :reports?

    @report = Reports::Dashboard::ApplicationsReport.new(kind: params[:kind])
    render partial: "admin/dashboard/totals_#{params[:kind]}/table_body"
  end

  def international_trade
    authorize :dashboard, :reports?

    @report = Reports::Dashboard::ApplicationsReport.new(kind: params[:kind], award_type: :trade)
    render partial: "admin/dashboard/totals_#{params[:kind]}/table_body"
  end

  def innovation
    authorize :dashboard, :reports?

    @report = Reports::Dashboard::ApplicationsReport.new(kind: params[:kind], award_type: :innovation)
    render partial: "admin/dashboard/totals_#{params[:kind]}/table_body"
  end

  def social_mobility
    authorize :dashboard, :reports?

    @report = Reports::Dashboard::ApplicationsReport.new(kind: params[:kind], award_type: :mobility)
    render partial: "admin/dashboard/totals_#{params[:kind]}/table_body"
  end

  def sustainable_development
    authorize :dashboard, :reports?

    @report = Reports::Dashboard::ApplicationsReport.new(kind: params[:kind], award_type: :development)
    render partial: "admin/dashboard/totals_#{params[:kind]}/table_body"
  end

  def account_registrations
    authorize :dashboard, :reports?

    @report = Reports::Dashboard::UsersReport.new(kind: params[:kind])
    render partial: "admin/dashboard/totals_#{params[:kind]}/users_table_body"
  end
end
