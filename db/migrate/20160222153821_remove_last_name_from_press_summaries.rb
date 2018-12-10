class RemoveLastNameFromPressSummaries < ActiveRecord::Migration[4.2]
  def change
    remove_column :press_summaries, :last_name
  end
end
