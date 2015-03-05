class CreateFormAnswerAssessments < ActiveRecord::Migration
  def change
    create_table :form_answer_assessments do |t|
      t.hstore :document
      t.integer :assessor_assignment_id, null: false
      t.timestamps null: false
    end

    add_index :form_answer_assessments, :assessor_assignment_id, unique: true
  end
end
