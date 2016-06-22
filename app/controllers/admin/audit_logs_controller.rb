class Admin::AuditLogsController < Admin::BaseController
  def index
    authorize :audit_log, :index?
    @audit_logs = AuditLog.all.order(id: :desc).page(params[:page])
  end
end
