class MakeAdminsConfirmable < ActiveRecord::Migration[4.2]
  def change
    add_column :admins, :confirmation_token, :string
    add_column :admins, :confirmed_at, :datetime
    add_column :admins, :confirmation_sent_at, :datetime
  end
end
