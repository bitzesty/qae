class AddSubmittedToPalaceInvites < ActiveRecord::Migration
  def change
    add_column :palace_invites, :submitted, :boolean, default: false
  end
end
