class AddCollaboratorsCheckedAtToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :collaborators_checked_at, :datetime
  end
end
