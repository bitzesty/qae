class AddDebounceApiLatestCheckAtToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :marked_as_bounces_email_at

    add_column :users, :marked_at_bounces_email, :boolean, default: false
    add_column :users, :debounce_api_latest_check_at, :datetime
  end
end
