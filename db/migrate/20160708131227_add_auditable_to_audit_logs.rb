class AddAuditableToAuditLogs < ActiveRecord::Migration
  def change
    add_column :audit_logs, :auditable_id, :integer
    add_column :audit_logs, :auditable_type, :string
  end
end
