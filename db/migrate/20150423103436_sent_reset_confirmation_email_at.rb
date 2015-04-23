class SentResetConfirmationEmailAt < ActiveRecord::Migration
  def change
    add_column :users, :sent_reset_confirmation_email, :datetime
  end
end
