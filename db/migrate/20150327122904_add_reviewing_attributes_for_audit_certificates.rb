class AddReviewingAttributesForAuditCertificates < ActiveRecord::Migration
  def change
    add_column :audit_certificates, :changes_description, :text
    add_column :audit_certificates, :reviewable_type, :string
    add_column :audit_certificates, :reviewable_id, :integer
    add_column :audit_certificates, :reviewed_at, :datetime
    add_column :audit_certificates, :status, :integer
  end
end
