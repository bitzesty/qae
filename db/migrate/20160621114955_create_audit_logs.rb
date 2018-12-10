class CreateAuditLogs < ActiveRecord::Migration[4.2]
  def change
    create_table :audit_logs do |t|
      t.integer :subject_id
      t.string :subject_type
      t.string :action_type

      t.timestamps null: false
    end
  end
end
