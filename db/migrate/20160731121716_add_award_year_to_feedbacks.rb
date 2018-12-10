class AddAwardYearToFeedbacks < ActiveRecord::Migration[4.2]
  def change
    add_reference :feedbacks, :award_year, index: true, foreign_key: true
  end
end
