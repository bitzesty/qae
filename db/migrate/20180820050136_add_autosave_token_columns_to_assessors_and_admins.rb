class AddAutosaveTokenColumnsToAssessorsAndAdmins < ActiveRecord::Migration[4.2]
  def change
    add_column :assessors, :autosave_token, :string, unique: true
    add_column :admins, :autosave_token, :string, unique: true
  end
end
