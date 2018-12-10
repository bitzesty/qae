class AddEditablePolymorphicAssociationToAssessorAssignments < ActiveRecord::Migration[4.2]
  def change
    add_column :assessor_assignments,
               :editable_type,
               :string

    add_column :assessor_assignments,
               :editable_id,
               :integer,
               index: true
  end
end
