class RemoveLastNameFromPressSummaries < ActiveRecord::Migration
  def change
    remove_column :press_summaries, :last_name
  end
end
