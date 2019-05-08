class AddMarkedAsBouncesEmailAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :marked_as_bounces_email_at, :datetime
  end
end
