class RemoveDefaultFromPressSummariesConfirm < ActiveRecord::Migration
  def change
    change_column_default :press_summaries, :correct, nil
  end
end
