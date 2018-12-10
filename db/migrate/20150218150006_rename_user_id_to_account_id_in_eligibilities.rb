class RenameUserIdToAccountIdInEligibilities < ActiveRecord::Migration[4.2]
  def change
    rename_column :eligibilities, :user_id, :account_id
  end
end
