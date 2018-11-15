class RemoveDefaultFromPressSummariesConfirm < ActiveRecord::Migration[4.2]
  def change
    change_column_default :press_summaries, :correct, nil
  end
end
