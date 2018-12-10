class AddLockedAtToFeedbacks < ActiveRecord::Migration[4.2]
  def change
    add_column :feedbacks, :locked_at, :datetime
  end
end
