class RemoveReviewedByUserFromPressSummaries < ActiveRecord::Migration[4.2]
  def change
    remove_column :press_summaries, :reviewed_by_user, :boolean
  end
end
