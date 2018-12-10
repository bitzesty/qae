class CreateAssessmentRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :assessment_roles do |t|
      t.integer :assessor_id, null: false
      t.string :category, null: false
      t.string :role, null: false

      t.timestamps
    end

    add_index :assessment_roles,
              [:assessor_id, :category, :role],
              unique: true,
              name: "assessment_roles_multiassignment_unique_index"
  end
end
