class ChangeDefaultValuesForNotificationColumnsInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :subscribed_to_emails, true
    change_column_default :users, :agree_being_contacted_by_department_of_business, true
  end
end
