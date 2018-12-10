class AddAwardYearToAssessorAssignments < ActiveRecord::Migration[4.2]
  def change
    add_reference :assessor_assignments, :award_year, index: true, foreign_key: true
  end
end
