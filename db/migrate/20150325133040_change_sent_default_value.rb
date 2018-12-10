class ChangeSentDefaultValue < ActiveRecord::Migration[4.2]
  def up
    change_column :email_notifications, :sent, :boolean, default: false
  end

  def change
    change_column :email_notifications, :sent, :boolean
  end
end
