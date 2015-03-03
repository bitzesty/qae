class CreateAssessorAssignments < ActiveRecord::Migration
  def change
    create_table :assessor_assignments do |t|
      t.integer :form_answer_id, null: false
      t.integer :assessor_id, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :assessor_assignments, [:assessor_id, :form_answer_id], unique: true
    add_index :assessor_assignments, [:form_answer_id, :position], unique: true
  end
end
