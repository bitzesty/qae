class RemoveApprovedFromFeedbacks < ActiveRecord::Migration
  def change
    remove_column :feedbacks, :approved
  end
end
