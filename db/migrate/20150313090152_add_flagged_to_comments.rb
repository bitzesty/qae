class AddFlaggedToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :flagged, :boolean, default: false
  end
end
