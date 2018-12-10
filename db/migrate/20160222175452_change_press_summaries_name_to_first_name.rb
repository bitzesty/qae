class ChangePressSummariesNameToFirstName < ActiveRecord::Migration[4.2]
  def change
    rename_column :press_summaries, :first_name, :name
  end
end
