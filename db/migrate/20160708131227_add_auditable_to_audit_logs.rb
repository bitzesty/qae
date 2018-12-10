class AddAuditableToAuditLogs < ActiveRecord::Migration[4.2]
  def change
    add_column :audit_logs, :auditable_id, :integer
    add_column :audit_logs, :auditable_type, :string
  end
end
