class AddAuthorableToPressSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :press_summaries, :authorable_type, :string
    add_column :press_summaries, :authorable_id, :integer
  end
end
