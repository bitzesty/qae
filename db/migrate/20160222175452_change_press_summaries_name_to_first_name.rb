class ChangePressSummariesNameToFirstName < ActiveRecord::Migration
  def change
    rename_column :press_summaries, :first_name, :name
  end
end
