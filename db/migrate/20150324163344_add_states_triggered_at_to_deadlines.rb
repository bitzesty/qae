class AddStatesTriggeredAtToDeadlines < ActiveRecord::Migration
  def change
    add_column :deadlines, :states_triggered_at, :datetime
  end
end
