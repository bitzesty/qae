class ChangeContactPreferenceDefaults < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :notification_when_innovation_award_open, from: true, to: false
    change_column_default :users, :notification_when_trade_award_open, from: true, to: false
    change_column_default :users, :notification_when_development_award_open, from: true, to: false
    change_column_default :users, :notification_when_mobility_award_open, from: true, to: false
    change_column_default :users, :notification_when_submission_deadline_is_coming, from: true, to: false
    change_column_default :users, :subscribed_to_emails, from: true, to: false
    change_column_default :users, :agree_being_contacted_by_department_of_business, from: true, to: false
  end
end
