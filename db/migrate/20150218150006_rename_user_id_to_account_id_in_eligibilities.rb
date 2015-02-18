class RenameUserIdToAccountIdInEligibilities < ActiveRecord::Migration
  def change
    rename_column :eligibilities, :user_id, :account_id
  end
end
