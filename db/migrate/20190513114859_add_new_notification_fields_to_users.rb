class AddNewNotificationFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notification_when_innovation_award_open, :boolean, default: true
    add_column :users, :notification_when_trade_award_open, :boolean, default: true
    add_column :users, :notification_when_development_award_open, :boolean, default: true
    add_column :users, :notification_when_mobility_award_open, :boolean, default: true
    add_column :users, :notification_when_submission_deadline_is_coming, :boolean, default: true
  end
end
