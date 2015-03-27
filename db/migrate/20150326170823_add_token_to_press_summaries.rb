class AddTokenToPressSummaries < ActiveRecord::Migration
  def change
    add_column :press_summaries, :token, :string
  end
end
