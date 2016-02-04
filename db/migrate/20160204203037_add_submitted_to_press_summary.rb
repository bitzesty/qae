class AddSubmittedToPressSummary < ActiveRecord::Migration
  def change
    add_column :press_summaries, :submitted, :boolean, default: false
  end
end
