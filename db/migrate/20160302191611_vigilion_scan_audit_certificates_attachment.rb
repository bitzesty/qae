class VigilionScanAuditCertificatesAttachment < ActiveRecord::Migration[4.2]
  def change
    add_column :audit_certificates, :attachment_scan_results, :string
  end
end
