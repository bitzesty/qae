class AddAwardYearToAssessorAssignments < ActiveRecord::Migration
  def change
    add_reference :assessor_assignments, :award_year, index: true, foreign_key: true
  end
end
