class AddSubmittedToPressSummary < ActiveRecord::Migration[4.2]
  def change
    add_column :press_summaries, :submitted, :boolean, default: false
  end
end
