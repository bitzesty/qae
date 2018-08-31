class AddAutosaveTokenColumnsToAssessorsAndAdmins < ActiveRecord::Migration
  def change
    add_column :assessors, :autosave_token, :string, unique: true
    add_column :admins, :autosave_token, :string, unique: true
  end
end
