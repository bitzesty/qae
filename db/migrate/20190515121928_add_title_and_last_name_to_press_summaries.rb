class AddTitleAndLastNameToPressSummaries < ActiveRecord::Migration[5.2]
  def change
    add_column :press_summaries, :title, :string
    add_column :press_summaries, :last_name, :string
  end
end
