class AddAuthorableToFeedbacks < ActiveRecord::Migration[4.2]
  def change
    add_column :feedbacks, :authorable_type, :string
    add_column :feedbacks, :authorable_id, :integer
  end
end
