class AddAwardYearToFeedbacks < ActiveRecord::Migration
  def change
    add_reference :feedbacks, :award_year, index: true, foreign_key: true
  end
end
