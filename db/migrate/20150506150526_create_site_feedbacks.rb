class CreateSiteFeedbacks < ActiveRecord::Migration[4.2]
  def change
    create_table :site_feedbacks do |t|
      t.integer :rating
      t.text :comment

      t.timestamps null: false
    end
  end
end
