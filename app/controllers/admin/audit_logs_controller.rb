class Admin::AuditLogsController < ApplicationController
  def index
    @audit_logs = AuditLog.all.order(id: :desc).page(params[:page])
  end
end
