class AddTokenToPressSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :press_summaries, :token, :string
  end
end
