class ChangeSentDefaultValue < ActiveRecord::Migration
  def up
    change_column :email_notifications, :sent, :boolean, default: false
  end

  def change
    change_column :email_notifications, :sent, :boolean
  end
end
