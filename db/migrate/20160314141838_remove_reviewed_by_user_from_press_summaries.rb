class RemoveReviewedByUserFromPressSummaries < ActiveRecord::Migration
  def change
    remove_column :press_summaries, :reviewed_by_user, :boolean
  end
end
