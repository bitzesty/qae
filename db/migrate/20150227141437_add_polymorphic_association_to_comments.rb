class AddPolymorphicAssociationToComments < ActiveRecord::Migration
  def change
    add_column :comments, :authorable_type, :string, null: false, index: true
    add_column :comments, :authorable_id, :integer, null: false, index: true
    remove_column :comments, :author_id
  end
end
