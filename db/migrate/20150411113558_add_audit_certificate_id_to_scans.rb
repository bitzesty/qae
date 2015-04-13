class AddAuditCertificateIdToScans < ActiveRecord::Migration
  def change
    add_column :scans, :audit_certificate_id, :integer
  end
end
