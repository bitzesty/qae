class CreateAuditCertificates < ActiveRecord::Migration
  def change
    create_table :audit_certificates do |t|
      t.references :form_answer, null: false, index: true
      t.string :attachment

      t.timestamps null: false
    end
  end
end
