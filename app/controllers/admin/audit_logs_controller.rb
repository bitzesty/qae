class Admin::AuditLogsController < Admin::BaseController
  def index
    authorize :audit_log, :index?
    @audit_logs = AuditLog.data_export.order(id: :desc).page(params[:page])
  end
end
