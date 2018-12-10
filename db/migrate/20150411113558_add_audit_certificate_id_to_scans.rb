class AddAuditCertificateIdToScans < ActiveRecord::Migration[4.2]
  def change
    add_column :scans, :audit_certificate_id, :integer
  end
end
