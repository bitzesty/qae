class VigilionScanAuditCertificatesAttachment < ActiveRecord::Migration
  def change
    add_column :audit_certificates, :attachment_scan_results, :string
  end
end