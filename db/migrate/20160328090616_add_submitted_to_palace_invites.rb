class AddSubmittedToPalaceInvites < ActiveRecord::Migration[4.2]
  def change
    add_column :palace_invites, :submitted, :boolean, default: false
  end
end
