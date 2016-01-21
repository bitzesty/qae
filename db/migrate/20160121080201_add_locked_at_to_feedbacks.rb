class AddLockedAtToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :locked_at, :datetime
  end
end
