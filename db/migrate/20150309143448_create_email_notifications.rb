class CreateEmailNotifications < ActiveRecord::Migration
  def change
    create_table :email_notifications do |t|
      t.string :kind
      t.boolean :sent
      t.datetime :trigger_at
      t.references :settings, index: true

      t.timestamps null: false
    end
  end
end
