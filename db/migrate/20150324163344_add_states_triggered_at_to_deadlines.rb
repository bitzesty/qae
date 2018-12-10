class AddStatesTriggeredAtToDeadlines < ActiveRecord::Migration[4.2]
  def change
    add_column :deadlines, :states_triggered_at, :datetime
  end
end
