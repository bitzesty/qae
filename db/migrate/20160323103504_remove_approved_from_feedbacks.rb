class RemoveApprovedFromFeedbacks < ActiveRecord::Migration[4.2]
  def change
    remove_column :feedbacks, :approved
  end
end
